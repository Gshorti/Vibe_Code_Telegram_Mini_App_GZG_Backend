package handler

import (
	"encoding/json"
	"errors"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/service"
)

type Handler struct {
	service       *service.Service
	botToken      string
	allowedOrigin string
}

func New(s *service.Service, botToken, allowedOrigin string) *Handler {
	return &Handler{service: s, botToken: botToken, allowedOrigin: allowedOrigin}
}

func (h *Handler) Routes() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /healthz", h.healthz)
	mux.HandleFunc("GET /topics", h.requireAuth(h.listTopics))
	mux.HandleFunc("GET /questions/feed", h.requireAuth(h.feed))
	mux.HandleFunc("POST /questions/{id}/answer", h.requireAuth(h.submitAnswer))
	mux.HandleFunc("GET /users/me/stats", h.requireAuth(h.stats))
	mux.HandleFunc("GET /users/me/history", h.requireAuth(h.history))
	return loggingMiddleware(corsMiddleware(h.allowedOrigin, mux))
}

func (h *Handler) healthz(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	_, _ = w.Write([]byte("ok"))
}

func (h *Handler) listTopics(w http.ResponseWriter, r *http.Request) {
	topics, err := h.service.Topics(r.Context())
	if err != nil {
		writeError(w, http.StatusInternalServerError, err)
		return
	}
	dtos := make([]topicDTO, 0, len(topics))
	for _, t := range topics {
		dtos = append(dtos, toTopicDTO(t))
	}
	writeJSON(w, http.StatusOK, dtos)
}

func (h *Handler) feed(w http.ResponseWriter, r *http.Request) {
	userID, ok := userIDFromContext(r.Context())
	if !ok {
		writeError(w, http.StatusUnauthorized, errMissingAuth)
		return
	}

	q := r.URL.Query()

	var topicID *int64
	if v := q.Get("topic"); v != "" {
		id, err := strconv.ParseInt(v, 10, 64)
		if err != nil {
			writeError(w, http.StatusBadRequest, errors.New("invalid topic"))
			return
		}
		topicID = &id
	}

	var difficulty *int
	if v := q.Get("difficulty"); v != "" {
		d, err := strconv.Atoi(v)
		if err != nil {
			writeError(w, http.StatusBadRequest, errors.New("invalid difficulty"))
			return
		}
		difficulty = &d
	}

	limit := service.DefaultFeedLimit
	if v := q.Get("limit"); v != "" {
		l, err := strconv.Atoi(v)
		if err != nil {
			writeError(w, http.StatusBadRequest, errors.New("invalid limit"))
			return
		}
		limit = l
	}

	questions, err := h.service.Feed(r.Context(), userID, topicID, difficulty, limit)
	if err != nil {
		writeServiceError(w, err)
		return
	}

	dtos := make([]questionDTO, 0, len(questions))
	for _, qn := range questions {
		dtos = append(dtos, toQuestionDTO(qn))
	}
	writeJSON(w, http.StatusOK, dtos)
}

func (h *Handler) submitAnswer(w http.ResponseWriter, r *http.Request) {
	userID, ok := userIDFromContext(r.Context())
	if !ok {
		writeError(w, http.StatusUnauthorized, errMissingAuth)
		return
	}

	questionID, err := strconv.ParseInt(r.PathValue("id"), 10, 64)
	if err != nil {
		writeError(w, http.StatusBadRequest, errors.New("invalid question id"))
		return
	}

	var req answerRequestDTO
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, errors.New("invalid request body"))
		return
	}

	result, err := h.service.SubmitAnswer(r.Context(), userID, questionID, req.OptionID)
	if err != nil {
		writeServiceError(w, err)
		return
	}

	writeJSON(w, http.StatusOK, answerResultDTO{
		Correct:         result.Correct,
		CorrectOptionID: result.CorrectOptionID,
	})
}

func (h *Handler) stats(w http.ResponseWriter, r *http.Request) {
	userID, ok := userIDFromContext(r.Context())
	if !ok {
		writeError(w, http.StatusUnauthorized, errMissingAuth)
		return
	}

	stats, err := h.service.Stats(r.Context(), userID)
	if err != nil {
		writeError(w, http.StatusInternalServerError, err)
		return
	}

	writeJSON(w, http.StatusOK, userStatsDTO{
		TotalAnswers:   stats.TotalAnswers,
		CorrectAnswers: stats.CorrectAnswers,
		Accuracy:       stats.Accuracy,
	})
}

func (h *Handler) history(w http.ResponseWriter, r *http.Request) {
	userID, ok := userIDFromContext(r.Context())
	if !ok {
		writeError(w, http.StatusUnauthorized, errMissingAuth)
		return
	}

	q := r.URL.Query()

	limit := service.DefaultFeedLimit
	if v := q.Get("limit"); v != "" {
		l, err := strconv.Atoi(v)
		if err != nil {
			writeError(w, http.StatusBadRequest, errors.New("invalid limit"))
			return
		}
		limit = l
	}

	offset := 0
	if v := q.Get("offset"); v != "" {
		o, err := strconv.Atoi(v)
		if err != nil {
			writeError(w, http.StatusBadRequest, errors.New("invalid offset"))
			return
		}
		offset = o
	}

	items, err := h.service.History(r.Context(), userID, limit, offset)
	if err != nil {
		writeServiceError(w, err)
		return
	}

	dtos := make([]historyItemDTO, 0, len(items))
	for _, it := range items {
		dtos = append(dtos, historyItemDTO{
			QuestionID:         it.QuestionID,
			CodeSnippet:        it.CodeSnippet,
			Options:            toAnswerOptionDTOs(it.Options),
			SelectedOptionText: it.SelectedOptionText,
			CorrectOptionText:  it.CorrectOptionText,
			Correct:            it.IsCorrect,
			AnsweredAt:         it.AnsweredAt.Format(time.RFC3339),
		})
	}
	writeJSON(w, http.StatusOK, dtos)
}

func writeServiceError(w http.ResponseWriter, err error) {
	switch {
	case errors.Is(err, service.ErrInvalidDifficulty), errors.Is(err, service.ErrInvalidLimit):
		writeError(w, http.StatusBadRequest, err)
	case errors.Is(err, service.ErrQuestionNotFound), errors.Is(err, service.ErrOptionNotFound):
		writeError(w, http.StatusNotFound, err)
	default:
		writeError(w, http.StatusInternalServerError, err)
	}
}

func writeJSON(w http.ResponseWriter, status int, body any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(body); err != nil {
		log.Printf("encode response: %v", err)
	}
}

func writeError(w http.ResponseWriter, status int, err error) {
	writeJSON(w, status, errorDTO{Error: err.Error()})
}
