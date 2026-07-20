package main

import (
	"context"
	"log"
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/config"
	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/handler"
	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/repo"
	"github.com/Gshorti/Vibe_Code_Telegram_Mini_App_GZG_Backend/internal/service"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("config: %v", err)
	}

	ctx := context.Background()
	pool, err := pgxpool.New(ctx, cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("db pool: %v", err)
	}
	defer pool.Close()

	if err := pool.Ping(ctx); err != nil {
		log.Fatalf("db ping: %v", err)
	}

	r := repo.New(pool)
	svc := service.New(r)
	h := handler.New(svc, cfg.TelegramToken)

	addr := ":" + cfg.HTTPPort
	log.Printf("listening on %s", addr)
	if err := http.ListenAndServe(addr, h.Routes()); err != nil {
		log.Fatalf("server: %v", err)
	}
}
