package handler

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/service"
)

func TestCORS_HeadersOnRegularRequest(t *testing.T) {
	h := newTestHandler()
	req := httptest.NewRequest(http.MethodGet, "/healthz", nil)
	rr := httptest.NewRecorder()
	h.Routes().ServeHTTP(rr, req)

	if got := rr.Header().Get("Access-Control-Allow-Origin"); got != "*" {
		t.Errorf("expected Access-Control-Allow-Origin=*, got %q", got)
	}
}

func TestCORS_Preflight(t *testing.T) {
	h := newTestHandler()
	req := httptest.NewRequest(http.MethodOptions, "/questions/1/answer", nil)
	req.Header.Set("Origin", "https://miniapp.example.com")
	req.Header.Set("Access-Control-Request-Method", "POST")
	req.Header.Set("Access-Control-Request-Headers", "Authorization")
	rr := httptest.NewRecorder()
	h.Routes().ServeHTTP(rr, req)

	if rr.Code != http.StatusNoContent {
		t.Fatalf("expected 204 for preflight, got %d", rr.Code)
	}
	if got := rr.Header().Get("Access-Control-Allow-Methods"); got == "" {
		t.Error("expected Access-Control-Allow-Methods to be set")
	}
	if got := rr.Header().Get("Access-Control-Allow-Headers"); got == "" {
		t.Error("expected Access-Control-Allow-Headers to be set")
	}
}

func TestCORS_SpecificOriginSetsVary(t *testing.T) {
	h := New(service.New(&fakeRepo{}), testBotToken, "https://miniapp.example.com")
	req := httptest.NewRequest(http.MethodGet, "/healthz", nil)
	rr := httptest.NewRecorder()
	h.Routes().ServeHTTP(rr, req)

	if got := rr.Header().Get("Access-Control-Allow-Origin"); got != "https://miniapp.example.com" {
		t.Errorf("expected specific origin, got %q", got)
	}
	if got := rr.Header().Get("Vary"); got != "Origin" {
		t.Errorf("expected Vary=Origin, got %q", got)
	}
}
