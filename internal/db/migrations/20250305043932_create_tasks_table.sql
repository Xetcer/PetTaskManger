-- +goose Up
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY, --Уникальный идентификатор задачи, автоинкремент.
    title VARCHAR(255) NOT NULL, --Заголовок задачи. Ограничение по длине 255 символов.
    description TEXT, --Описание задачи(необзятально).
    due_date TIMESTAMP, -- срок выполнения задачи(необзятельно).
    status task_status DEFAULT 'in progress', --Статус задачи 'in progress', 'completed'.
    priority task_priority DEFAULT 'normal', --Важность задачи 'no matter', 'normal', 'important'.
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp, --Дата и время создания задачи. По умолчанию текущая дата/время.
    updated_at TIMESTAMP DEFAULT current_timestamp --Дата и время последнего обновления задачи (необязательно). По умолчанию текущая дата/время.
);

-- +goose Down
DROP table tasks;
