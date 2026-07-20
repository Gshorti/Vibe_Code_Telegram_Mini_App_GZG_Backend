package handler

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"net/http"
	"net/http/httptest"
	"net/url"
	"strconv"
	"strings"
	"testing"
	"time"

	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/model"
	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/repo"
	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/service"
)

type fakeRepo struct{}

func (f *fakeRepo) ListTopics(ctx context.Context) ([]model.Topic, error) { return nil, nil }
func (f *fakeRepo) FeedQuestions(ctx context.Context, userID int64, topicID *int64, difficulty *int, limit int) ([]model.Question, error) {
	return nil, nil
}
func (f *fakeRepo) GetQuestionWithOptions(ctx context.Context, questionID int64) (*model.Question, error) {
	return nil, nil
}
func (f *fakeRepo) UpsertUserByTelegramID(ctx context.Context, telegramID int64) (int64, error) {
	return telegramID, nil
}
func (f *fakeRepo) RecordAttempt(ctx context.Context, a model.Attempt) error { return nil }
func (f *fakeRepo) UserStats(ctx context.Context, userID int64) (repo.Stats, error) {
	return repo.Stats{}, nil
}

func (f *fakeRepo) UserHistory(ctx context.Context, userID int64, limit, offset int) ([]repo.HistoryItem, error) {
	return nil, nil
}

const testBotToken = "test-bot-token"

func validInitData(t *testing.T, telegramID int64) string {
	t.Helper()
	values := url.Values{}
	values.Set("auth_date", strconv.FormatInt(time.Now().Unix(), 10))
	values.Set("user", `{"id":`+strconv.FormatInt(telegramID, 10)+`}`)

	dataCheckString := "auth_date=" + values.Get("auth_date") + "\nuser=" + values.Get("user")

	secretKey := hmac.New(sha256.New, []byte("WebAppData"))
	secretKey.Write([]byte(testBotToken))
	mac := hmac.New(sha256.New, secretKey.Sum(nil))
	mac.Write([]byte(dataCheckString))
	hash := hex.EncodeToString(mac.Sum(nil))

	values.Set("hash", hash)
	return values.Encode()
}

func newTestHandler() *Handler {
	return New(service.New(&fakeRepo{}), testBotToken, "*")
}

func TestHealthz(t *testing.T) {
	h := newTestHandler()
	req := httptest.NewRequest(http.MethodGet, "/healthz", nil)
	rr := httptest.NewRecorder()
	h.Routes().ServeHTTP(rr, req)
	if rr.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", rr.Code)
	}
}

func TestRequireAuth_MissingHeader(t *testing.T) {
	h := newTestHandler()
	req := httptest.NewRequest(http.MethodGet, "/topics", nil)
	rr := httptest.NewRecorder()
	h.Routes().ServeHTTP(rr, req)
	if rr.Code != http.StatusUnauthorized {
		t.Fatalf("expected 401, got %d", rr.Code)
	}
}

func TestRequireAuth_InvalidSignature(t *testing.T) {
	h := newTestHandler()
	req := httptest.NewRequest(http.MethodGet, "/topics", nil)
	req.Header.Set("Authorization", "tma auth_date=1&hash=deadbeef&user=%7B%22id%22%3A1%7D")
	rr := httptest.NewRecorder()
	h.Routes().ServeHTTP(rr, req)
	if rr.Code != http.StatusUnauthorized {
		t.Fatalf("expected 401, got %d", rr.Code)
	}
}

func TestRequireAuth_ValidSignature(t *testing.T) {
	h := newTestHandler()
	req := httptest.NewRequest(http.MethodGet, "/topics", nil)
	req.Header.Set("Authorization", "tma "+validInitData(t, 12345))
	rr := httptest.NewRecorder()
	h.Routes().ServeHTTP(rr, req)
	if rr.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d, body=%s", rr.Code, rr.Body.String())
	}
}

func TestSubmitAnswer_QuestionNotFound(t *testing.T) {
	h := newTestHandler()
	req := httptest.NewRequest(http.MethodPost, "/questions/1/answer", strings.NewReader(`{"optionId":1}`))
	req.Header.Set("Authorization", "tma "+validInitData(t, 12345))
	rr := httptest.NewRecorder()
	h.Routes().ServeHTTP(rr, req)
	if rr.Code != http.StatusNotFound {
		t.Fatalf("expected 404, got %d, body=%s", rr.Code, rr.Body.String())
	}
}
