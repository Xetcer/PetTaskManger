-- +goose Up
CREATE TYPE task_priority  AS ENUM('no matter', 'normal', 'important');

-- +goose Down
DROP TYPE task_priority;
