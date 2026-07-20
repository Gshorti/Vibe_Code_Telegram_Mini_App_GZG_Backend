package config

import "testing"

func TestLoad_MissingDatabaseURL(t *testing.T) {
	t.Setenv("DATABASE_URL", "")
	t.Setenv("TELEGRAM_BOT_TOKEN", "token")

	if _, err := Load(); err == nil {
		t.Fatal("expected error when DATABASE_URL is missing")
	}
}

func TestLoad_MissingTelegramToken(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://x")
	t.Setenv("TELEGRAM_BOT_TOKEN", "")

	if _, err := Load(); err == nil {
		t.Fatal("expected error when TELEGRAM_BOT_TOKEN is missing")
	}
}

func TestLoad_DefaultsAndOverrides(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://x")
	t.Setenv("TELEGRAM_BOT_TOKEN", "token")
	t.Setenv("HTTP_PORT", "")

	cfg, err := Load()
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if cfg.HTTPPort != "8080" {
		t.Errorf("expected default HTTP_PORT=8080, got %q", cfg.HTTPPort)
	}

	t.Setenv("HTTP_PORT", "9090")
	cfg, err = Load()
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if cfg.HTTPPort != "9090" {
		t.Errorf("expected HTTP_PORT=9090, got %q", cfg.HTTPPort)
	}
}
