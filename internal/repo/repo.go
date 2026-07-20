package repo

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/model"
)

type Repo struct {
	db *pgxpool.Pool
}

func New(db *pgxpool.Pool) *Repo {
	return &Repo{db: db}
}

func (r *Repo) ListTopics(ctx context.Context) ([]model.Topic, error) {
	rows, err := r.db.Query(ctx, `SELECT id, name FROM topics ORDER BY name`)
	if err != nil {
		return nil, fmt.Errorf("query topics: %w", err)
	}
	defer rows.Close()

	var topics []model.Topic
	for rows.Next() {
		var t model.Topic
		if err := rows.Scan(&t.ID, &t.Name); err != nil {
			return nil, fmt.Errorf("scan topic: %w", err)
		}
		topics = append(topics, t)
	}
	return topics, rows.Err()
}

// FeedQuestions returns up to limit questions matching the optional filters
// that the user has not yet attempted, each with its answer options.
func (r *Repo) FeedQuestions(ctx context.Context, userID int64, topicID *int64, difficulty *int, limit int) ([]model.Question, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, topic_id, difficulty, code_snippet, created_at
		FROM questions q
		WHERE ($1::bigint IS NULL OR topic_id = $1)
		  AND ($2::smallint IS NULL OR difficulty = $2)
		  AND NOT EXISTS (
		      SELECT 1 FROM attempts a
		      WHERE a.user_id = $3 AND a.question_id = q.id
		  )
		ORDER BY random()
		LIMIT $4
	`, topicID, difficulty, userID, limit)
	if err != nil {
		return nil, fmt.Errorf("query feed questions: %w", err)
	}
	defer rows.Close()

	var questions []model.Question
	for rows.Next() {
		var q model.Question
		if err := rows.Scan(&q.ID, &q.TopicID, &q.Difficulty, &q.CodeSnippet, &q.CreatedAt); err != nil {
			return nil, fmt.Errorf("scan question: %w", err)
		}
		questions = append(questions, q)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}

	if err := r.attachOptions(ctx, questions); err != nil {
		return nil, err
	}
	return questions, nil
}

func (r *Repo) attachOptions(ctx context.Context, questions []model.Question) error {
	if len(questions) == 0 {
		return nil
	}
	ids := make([]int64, len(questions))
	byID := make(map[int64]*model.Question, len(questions))
	for i := range questions {
		ids[i] = questions[i].ID
		byID[questions[i].ID] = &questions[i]
	}

	rows, err := r.db.Query(ctx, `
		SELECT id, question_id, text, is_correct
		FROM answer_options
		WHERE question_id = ANY($1)
		ORDER BY id
	`, ids)
	if err != nil {
		return fmt.Errorf("query answer options: %w", err)
	}
	defer rows.Close()

	for rows.Next() {
		var o model.AnswerOption
		if err := rows.Scan(&o.ID, &o.QuestionID, &o.Text, &o.IsCorrect); err != nil {
			return fmt.Errorf("scan answer option: %w", err)
		}
		if q, ok := byID[o.QuestionID]; ok {
			q.Options = append(q.Options, o)
		}
	}
	return rows.Err()
}

func (r *Repo) GetQuestionWithOptions(ctx context.Context, questionID int64) (*model.Question, error) {
	var q model.Question
	err := r.db.QueryRow(ctx, `
		SELECT id, topic_id, difficulty, code_snippet, created_at
		FROM questions WHERE id = $1
	`, questionID).Scan(&q.ID, &q.TopicID, &q.Difficulty, &q.CodeSnippet, &q.CreatedAt)
	if err != nil {
		return nil, err
	}

	questions := []model.Question{q}
	if err := r.attachOptions(ctx, questions); err != nil {
		return nil, err
	}
	return &questions[0], nil
}

// UpsertUserByTelegramID returns the internal user id for the given Telegram
// id, creating the user if it does not exist yet.
func (r *Repo) UpsertUserByTelegramID(ctx context.Context, telegramID int64) (int64, error) {
	var id int64
	err := r.db.QueryRow(ctx, `
		INSERT INTO users (telegram_id) VALUES ($1)
		ON CONFLICT (telegram_id) DO UPDATE SET telegram_id = EXCLUDED.telegram_id
		RETURNING id
	`, telegramID).Scan(&id)
	if err != nil {
		return 0, fmt.Errorf("upsert user: %w", err)
	}
	return id, nil
}

func (r *Repo) RecordAttempt(ctx context.Context, a model.Attempt) error {
	_, err := r.db.Exec(ctx, `
		INSERT INTO attempts (user_id, question_id, selected_option_id, is_correct)
		VALUES ($1, $2, $3, $4)
	`, a.UserID, a.QuestionID, a.SelectedOptionID, a.IsCorrect)
	if err != nil {
		return fmt.Errorf("record attempt: %w", err)
	}
	return nil
}

type Stats struct {
	TotalAnswers   int64
	CorrectAnswers int64
}

func (r *Repo) UserStats(ctx context.Context, userID int64) (Stats, error) {
	var s Stats
	err := r.db.QueryRow(ctx, `
		SELECT count(*), count(*) FILTER (WHERE is_correct)
		FROM attempts WHERE user_id = $1
	`, userID).Scan(&s.TotalAnswers, &s.CorrectAnswers)
	if err != nil {
		return Stats{}, fmt.Errorf("query user stats: %w", err)
	}
	return s, nil
}
