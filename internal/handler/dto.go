package handler

import "github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/model"

type topicDTO struct {
	ID   int64  `json:"id"`
	Name string `json:"name"`
}

type answerOptionDTO struct {
	ID   int64  `json:"id"`
	Text string `json:"text"`
}

type questionDTO struct {
	ID          int64             `json:"id"`
	TopicID     int64             `json:"topicId"`
	Difficulty  int               `json:"difficulty"`
	CodeSnippet string            `json:"codeSnippet"`
	Options     []answerOptionDTO `json:"options"`
}

type answerRequestDTO struct {
	OptionID int64 `json:"optionId"`
}

type answerResultDTO struct {
	Correct         bool  `json:"correct"`
	CorrectOptionID int64 `json:"correctOptionId"`
}

type userStatsDTO struct {
	TotalAnswers   int64   `json:"totalAnswers"`
	CorrectAnswers int64   `json:"correctAnswers"`
	Accuracy       float64 `json:"accuracy"`
}

type errorDTO struct {
	Error string `json:"error"`
}

func toTopicDTO(t model.Topic) topicDTO {
	return topicDTO{ID: t.ID, Name: t.Name}
}

// toQuestionDTO never includes which option is correct.
func toQuestionDTO(q model.Question) questionDTO {
	options := make([]answerOptionDTO, 0, len(q.Options))
	for _, o := range q.Options {
		options = append(options, answerOptionDTO{ID: o.ID, Text: o.Text})
	}
	return questionDTO{
		ID:          q.ID,
		TopicID:     q.TopicID,
		Difficulty:  q.Difficulty,
		CodeSnippet: q.CodeSnippet,
		Options:     options,
	}
}
