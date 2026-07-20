package service

import (
	"context"
	"testing"

	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/model"
	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/repo"
)

type fakeRepo struct {
	topics    []model.Topic
	questions map[int64]*model.Question
	stats     repo.Stats
	attempts  []model.Attempt
}

func (f *fakeRepo) ListTopics(ctx context.Context) ([]model.Topic, error) {
	return f.topics, nil
}

func (f *fakeRepo) FeedQuestions(ctx context.Context, userID int64, topicID *int64, difficulty *int, limit int) ([]model.Question, error) {
	return nil, nil
}

func (f *fakeRepo) GetQuestionWithOptions(ctx context.Context, questionID int64) (*model.Question, error) {
	return f.questions[questionID], nil
}

func (f *fakeRepo) UpsertUserByTelegramID(ctx context.Context, telegramID int64) (int64, error) {
	return 42, nil
}

func (f *fakeRepo) RecordAttempt(ctx context.Context, a model.Attempt) error {
	f.attempts = append(f.attempts, a)
	return nil
}

func (f *fakeRepo) UserStats(ctx context.Context, userID int64) (repo.Stats, error) {
	return f.stats, nil
}

func questionFixture() *model.Question {
	return &model.Question{
		ID: 1,
		Options: []model.AnswerOption{
			{ID: 10, Text: "1", IsCorrect: false},
			{ID: 11, Text: "2", IsCorrect: true},
		},
	}
}

func TestSubmitAnswer_Correct(t *testing.T) {
	fr := &fakeRepo{questions: map[int64]*model.Question{1: questionFixture()}}
	s := New(fr)

	res, err := s.SubmitAnswer(context.Background(), 42, 1, 11)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !res.Correct {
		t.Errorf("expected correct=true")
	}
	if res.CorrectOptionID != 11 {
		t.Errorf("expected correctOptionID=11, got %d", res.CorrectOptionID)
	}
	if len(fr.attempts) != 1 || !fr.attempts[0].IsCorrect {
		t.Errorf("expected one correct attempt to be recorded, got %+v", fr.attempts)
	}
}

func TestSubmitAnswer_Incorrect(t *testing.T) {
	fr := &fakeRepo{questions: map[int64]*model.Question{1: questionFixture()}}
	s := New(fr)

	res, err := s.SubmitAnswer(context.Background(), 42, 1, 10)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if res.Correct {
		t.Errorf("expected correct=false")
	}
	if res.CorrectOptionID != 11 {
		t.Errorf("expected correctOptionID=11, got %d", res.CorrectOptionID)
	}
}

func TestSubmitAnswer_QuestionNotFound(t *testing.T) {
	fr := &fakeRepo{questions: map[int64]*model.Question{}}
	s := New(fr)

	_, err := s.SubmitAnswer(context.Background(), 42, 99, 1)
	if err != ErrQuestionNotFound {
		t.Fatalf("expected ErrQuestionNotFound, got %v", err)
	}
}

func TestSubmitAnswer_OptionNotFound(t *testing.T) {
	fr := &fakeRepo{questions: map[int64]*model.Question{1: questionFixture()}}
	s := New(fr)

	_, err := s.SubmitAnswer(context.Background(), 42, 1, 999)
	if err != ErrOptionNotFound {
		t.Fatalf("expected ErrOptionNotFound, got %v", err)
	}
}

func TestFeed_InvalidDifficulty(t *testing.T) {
	s := New(&fakeRepo{})
	bad := 5
	_, err := s.Feed(context.Background(), 1, nil, &bad, 10)
	if err != ErrInvalidDifficulty {
		t.Fatalf("expected ErrInvalidDifficulty, got %v", err)
	}
}

func TestFeed_InvalidLimit(t *testing.T) {
	s := New(&fakeRepo{})
	_, err := s.Feed(context.Background(), 1, nil, nil, 1000)
	if err != ErrInvalidLimit {
		t.Fatalf("expected ErrInvalidLimit, got %v", err)
	}
}

func TestFeed_DefaultLimit(t *testing.T) {
	s := New(&fakeRepo{})
	if _, err := s.Feed(context.Background(), 1, nil, nil, 0); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestStats_Accuracy(t *testing.T) {
	fr := &fakeRepo{stats: repo.Stats{TotalAnswers: 4, CorrectAnswers: 3}}
	s := New(fr)

	stats, err := s.Stats(context.Background(), 42)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if stats.Accuracy != 0.75 {
		t.Errorf("expected accuracy=0.75, got %v", stats.Accuracy)
	}
}

func TestStats_ZeroAnswers(t *testing.T) {
	s := New(&fakeRepo{stats: repo.Stats{}})
	stats, err := s.Stats(context.Background(), 42)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if stats.Accuracy != 0 {
		t.Errorf("expected accuracy=0, got %v", stats.Accuracy)
	}
}
