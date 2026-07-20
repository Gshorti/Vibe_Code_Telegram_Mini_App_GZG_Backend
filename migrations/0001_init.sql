CREATE TABLE topics (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE questions (
    id           SERIAL PRIMARY KEY,
    topic_id     INTEGER NOT NULL REFERENCES topics(id),
    difficulty   SMALLINT NOT NULL CHECK (difficulty BETWEEN 1 AND 3),
    code_snippet TEXT NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_questions_topic_difficulty ON questions (topic_id, difficulty);

CREATE TABLE answer_options (
    id          SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL REFERENCES questions(id),
    text        TEXT NOT NULL,
    is_correct  BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX idx_answer_options_question ON answer_options (question_id);

CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    telegram_id BIGINT NOT NULL UNIQUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE attempts (
    id                SERIAL PRIMARY KEY,
    user_id           INTEGER NOT NULL REFERENCES users(id),
    question_id       INTEGER NOT NULL REFERENCES questions(id),
    selected_option_id INTEGER NOT NULL REFERENCES answer_options(id),
    is_correct        BOOLEAN NOT NULL,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_attempts_user_question ON attempts (user_id, question_id);
CREATE INDEX idx_attempts_user_created ON attempts (user_id, created_at);
