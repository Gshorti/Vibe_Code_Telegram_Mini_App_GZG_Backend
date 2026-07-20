package config

import (
	"fmt"
	"os"
)

type Config struct {
	HTTPPort      string
	DatabaseURL   string
	TelegramToken string
}

func Load() (Config, error) {
	cfg := Config{
		HTTPPort:      getEnv("HTTP_PORT", "8080"),
		DatabaseURL:   os.Getenv("DATABASE_URL"),
		TelegramToken: os.Getenv("TELEGRAM_BOT_TOKEN"),
	}

	if cfg.DatabaseURL == "" {
		return Config{}, fmt.Errorf("DATABASE_URL is required")
	}
	if cfg.TelegramToken == "" {
		return Config{}, fmt.Errorf("TELEGRAM_BOT_TOKEN is required")
	}

	return cfg, nil
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
