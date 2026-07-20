package service

import (
	"context"
	"errors"
	"fmt"

	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/model"
	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/repo"
)

var (
	ErrInvalidDifficulty = errors.New("difficulty must be between 1 and 3")
	ErrInvalidLimit      = errors.New("limit must be between 1 and 50")
	ErrQuestionNotFound  = errors.New("question not found")
	ErrOptionNotFound    = errors.New("answer option not found")
)

const (
	DefaultFeedLimit = 10
	MaxFeedLimit     = 50
)

// Repo is the subset of repo.Repo the service depends on, kept as an
// interface only so unit tests can substitute a fake implementation.
type Repo interface {
	ListTopics(ctx context.Context) ([]model.Topic, error)
	FeedQuestions(ctx context.Context, userID int64, topicID *int64, difficulty *int, limit int) ([]model.Question, error)
	GetQuestionWithOptions(ctx context.Context, questionID int64) (*model.Question, error)
	UpsertUserByTelegramID(ctx context.Context, telegramID int64) (int64, error)
	RecordAttempt(ctx context.Context, a model.Attempt) error
	UserStats(ctx context.Context, userID int64) (repo.Stats, error)
}

type Service struct {
	repo Repo
}

func New(r Repo) *Service {
	return &Service{repo: r}
}

func (s *Service) Topics(ctx context.Context) ([]model.Topic, error) {
	return s.repo.ListTopics(ctx)
}

func (s *Service) ResolveUser(ctx context.Context, telegramID int64) (int64, error) {
	return s.repo.UpsertUserByTelegramID(ctx, telegramID)
}

func (s *Service) Feed(ctx context.Context, userID int64, topicID *int64, difficulty *int, limit int) ([]model.Question, error) {
	if difficulty != nil && (*difficulty < 1 || *difficulty > 3) {
		return nil, ErrInvalidDifficulty
	}
	if limit <= 0 {
		limit = DefaultFeedLimit
	}
	if limit > MaxFeedLimit {
		return nil, ErrInvalidLimit
	}
	return s.repo.FeedQuestions(ctx, userID, topicID, difficulty, limit)
}

type AnswerResult struct {
	Correct         bool
	CorrectOptionID int64
}

func (s *Service) SubmitAnswer(ctx context.Context, userID, questionID, optionID int64) (AnswerResult, error) {
	q, err := s.repo.GetQuestionWithOptions(ctx, questionID)
	if err != nil {
		return AnswerResult{}, fmt.Errorf("get question: %w", err)
	}
	if q == nil {
		return AnswerResult{}, ErrQuestionNotFound
	}

	var selected *model.AnswerOption
	var correctOptionID int64
	for i := range q.Options {
		if q.Options[i].IsCorrect {
			correctOptionID = q.Options[i].ID
		}
		if q.Options[i].ID == optionID {
			selected = &q.Options[i]
		}
	}
	if selected == nil {
		return AnswerResult{}, ErrOptionNotFound
	}

	result := AnswerResult{
		Correct:         selected.IsCorrect,
		CorrectOptionID: correctOptionID,
	}

	err = s.repo.RecordAttempt(ctx, model.Attempt{
		UserID:           userID,
		QuestionID:       questionID,
		SelectedOptionID: optionID,
		IsCorrect:        result.Correct,
	})
	if err != nil {
		return AnswerResult{}, fmt.Errorf("record attempt: %w", err)
	}

	return result, nil
}

type Stats struct {
	TotalAnswers   int64
	CorrectAnswers int64
	Accuracy       float64
}

func (s *Service) Stats(ctx context.Context, userID int64) (Stats, error) {
	raw, err := s.repo.UserStats(ctx, userID)
	if err != nil {
		return Stats{}, err
	}
	stats := Stats{
		TotalAnswers:   raw.TotalAnswers,
		CorrectAnswers: raw.CorrectAnswers,
	}
	if stats.TotalAnswers > 0 {
		stats.Accuracy = float64(stats.CorrectAnswers) / float64(stats.TotalAnswers)
	}
	return stats, nil
}
