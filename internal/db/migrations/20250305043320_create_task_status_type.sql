-- +goose Up
CREATE TYPE task_status AS ENUM('in progress', 'completed');

-- +goose Down
DROP TYPE task_status;

