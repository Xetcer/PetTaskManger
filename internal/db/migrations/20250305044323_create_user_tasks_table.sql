-- +goose Up
CREATE TABLE IF NOT EXISTS user_tasks(
    id SERIAL PRIMARY KEY, --Первичный ключ
    user_id INT NOT NULL, --Идентификатор пользователя  
    task_id INT NOT NULL, --Идентификатор задачи  
    UNIQUE (user_id, task_id)
);


-- +goose Down
DROP TABLE user_tasks;
