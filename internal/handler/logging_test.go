package handler

import (
	"bytes"
	"log"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestLoggingMiddleware_LogsMethodPathStatus(t *testing.T) {
	var buf bytes.Buffer
	origOutput := log.Writer()
	log.SetOutput(&buf)
	defer log.SetOutput(origOutput)

	h := newTestHandler()
	req := httptest.NewRequest(http.MethodGet, "/healthz", nil)
	rr := httptest.NewRecorder()
	h.Routes().ServeHTTP(rr, req)

	logged := buf.String()
	if !strings.Contains(logged, "GET") || !strings.Contains(logged, "/healthz") || !strings.Contains(logged, "200") {
		t.Fatalf("expected log line with method, path, status, got: %q", logged)
	}
}

func TestLoggingMiddleware_LogsUnauthorizedStatus(t *testing.T) {
	var buf bytes.Buffer
	origOutput := log.Writer()
	log.SetOutput(&buf)
	defer log.SetOutput(origOutput)

	h := newTestHandler()
	req := httptest.NewRequest(http.MethodGet, "/topics", nil)
	rr := httptest.NewRecorder()
	h.Routes().ServeHTTP(rr, req)

	logged := buf.String()
	if !strings.Contains(logged, "401") {
		t.Fatalf("expected log line with status 401, got: %q", logged)
	}
}
