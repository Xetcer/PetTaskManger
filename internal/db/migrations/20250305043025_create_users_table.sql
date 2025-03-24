-- +goose Up
CREATE TABLE IF NOT EXISTS users (
id SERIAL PRIMARY KEY, --Уникальный идентификатор пользователя. Автоинкремент. (PRIMARY KEY)
username VARCHAR(50) NOT NULL, --Имя пользователя. Ограничение по длине 50 символов.
password_hash VARCHAR(255) NOT NULL, --Хэш пароля для безопасности.
created_at TIMESTAMP NOT NULL DEFAULT current_timestamp, --дата и время создания аккаунта, по умолчанию текущая дата/время.
UNIQUE(username)
);


-- +goose Down
DROP TABLE users;
