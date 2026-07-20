package model

import "time"

type Topic struct {
	ID   int64
	Name string
}

type Question struct {
	ID          int64
	TopicID     int64
	Difficulty  int
	CodeSnippet string
	CreatedAt   time.Time
	Options     []AnswerOption
}

type AnswerOption struct {
	ID         int64
	QuestionID int64
	Text       string
	IsCorrect  bool
}

type User struct {
	ID         int64
	TelegramID int64
	CreatedAt  time.Time
}

type Attempt struct {
	ID               int64
	UserID           int64
	QuestionID       int64
	SelectedOptionID int64
	IsCorrect        bool
	CreatedAt        time.Time
}
