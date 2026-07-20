# Python Output Quiz — Backend

Backend для Telegram Mini App: пользователю показывают сниппет кода на Python
и несколько вариантов ответа, нужно предсказать вывод программы. 3 уровня
сложности, несколько тем (строки, списки, циклы).

Подробности требований и архитектуры — в [TASK.md](TASK.md). Контракт API —
в [openapi.yaml](openapi.yaml).

## Стек

- Go (`net/http`, без веб-фреймворков)
- PostgreSQL 16 (драйвер `pgx/v5`)
- Docker / docker-compose

## Архитектура

```
cmd/api          # точка входа, сборка зависимостей
internal/
  config          # конфигурация из переменных окружения
  handler         # HTTP-роутинг, обработчики, Telegram initData middleware
  service         # бизнес-логика
  repo            # доступ к Postgres
  model           # доменные структуры
migrations/       # SQL-миграции (применяются автоматически при первом старте БД)
```

Слои зависят друг от друга линейно: `handler → service → repo → model`.

## Запуск

1. Скопируйте `.env.example` в `.env` и укажите реальный `TELEGRAM_BOT_TOKEN`
   (токен бота, которому принадлежит Mini App — нужен для проверки подписи
   `initData`).

   ```
   cp .env.example .env
   ```

2. Поднимите стек:

   ```
   docker compose up -d --build
   ```

   При первом старте Postgres автоматически применит SQL-файлы из
   `migrations/` (схема + тестовые сиды: 3 темы, 9 вопросов).

3. Проверьте, что сервис жив:

   ```
   curl http://localhost:8080/healthz
   ```

Все эндпоинты, кроме `/healthz`, требуют заголовок
`Authorization: tma <telegram initData>` — see openapi.yaml для деталей.

## Тесты

```
go test ./...
```

Юнит-тесты покрывают `config`, `service` (валидация, проверка ответа,
статистика — через фейковый repo) и `handler` (HTTP-роутинг, валидация
подписи Telegram initData). Для `repo` отдельных юнит-тестов нет — это
тонкая обёртка над Postgres, проверенная вручную end-to-end через
`docker compose up` (миграции, сиды, все эндпоинты с реальным initData).

## Миграции

Новая схема добавляется отдельным пронумерованным файлом в `migrations/`
(например, `0003_...sql`). На MVP-этапе миграции применяются один раз при
инициализации пустого volume Postgres (`docker-entrypoint-initdb.d`); при
необходимости накатывать миграции на уже работающую БД в будущем стоит
перейти на полноценный инструмент вроде `golang-migrate`.
