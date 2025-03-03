package db

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq" // Импортируем драйвер PostgreSQL
)

// createDB созадем нужную БД, вернем ее или ошибку
func CreateDB(db *sql.DB, name string) error {
	if db != nil {
		createStr := fmt.Sprintf("CREATE DATABASE %s;", name)
		_, err := db.Exec(createStr)
		return err
	} else {
		return fmt.Errorf("Empty db pointer")
	}
}

// createUsersTab создает таблицу пользователей
func createUsersTab(db *sql.DB) (sql.Result, error) {
	str := `CREATE TABLE IF NOT EXISTS users (
		id SERIAL PRIMARY KEY, --Уникальный идентификатор пользователя. Автоинкремент. (PRIMARY KEY)
		username VARCHAR(50) NOT NULL, --Имя пользователя. Ограничение по длине 50 символов.
		password_hash VARCHAR(255) NOT NULL, --Хэш пароля для безопасности.
		created_at TIMESTAMP NOT NULL DEFAULT current_timestamp, --дата и время создания аккаунта, по умолчанию текущая дата/время.
		UNIQUE(username)
		);`
	return db.Exec(str)
}

// createTypes создаем свои типы для таблицы tasks
func createTypes(db *sql.DB) (sql.Result, error) {
	queryStr := `CREATE TYPE task_status AS ENUM('in progress', 'completed');`
	result, err := db.Exec(queryStr)
	if err != nil {
		return result, err
	}
	queryStr = `CREATE TYPE task_priority  AS ENUM('no matter', 'normal', 'important');`
	result, err = db.Exec(queryStr)
	if err != nil {
		return result, err
	}
	return result, err
}

// dropTypes удаляет типы для таблицы tasks
func dropTypes(db *sql.DB) (sql.Result, error) {
	queryStr := `DROP TYPE task_status;`
	result, err := db.Exec(queryStr)
	queryStr = `DROP TYPE task_priority;`
	result, err = db.Exec(queryStr)
	return result, err
}

// creteTasksTab создаем таблицу задач
func creteTasksTab(db *sql.DB) (sql.Result, error) {
	result, err := createTypes(db)
	if err != nil {
		return result, err
	}

	str := `CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY, --Уникальный идентификатор задачи, автоинкремент.
    title VARCHAR(255) NOT NULL, --Заголовок задачи. Ограничение по длине 255 символов.
    description TEXT, --Описание задачи(необзятально).
    due_date TIMESTAMP, -- срок выполнения задачи(необзятельно).
    status task_status DEFAULT 'in progress', --Статус задачи 'in progress', 'completed'.
    priority task_priority DEFAULT 'normal', --Важность задачи 'no matter', 'normal', 'important'.
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp, --Дата и время создания задачи. По умолчанию текущая дата/время.
    updated_at TIMESTAMP DEFAULT current_timestamp --Дата и время последнего обновления задачи (необязательно). По умолчанию текущая дата/время.
	);`
	return db.Exec(str)
}

func creatUserTasksTab(db *sql.DB) (sql.Result, error) {
	str := `CREATE TABLE IF NOT EXISTS user_tasks(
    id SERIAL PRIMARY KEY, --Первичный ключ
    user_id INT NOT NULL, --Идентификатор пользователя  
    task_id INT NOT NULL, --Идентификатор задачи  
    UNIQUE (user_id, task_id)
	);`
	return db.Exec(str)
}

/*
CreateTables создает таблицы
-users - пользователи
-tasks - задачи
-user_tasks - нормализация пользователей и задач
*/
func CreateTables(db *sql.DB) error {
	result, err := createUsersTab(db)
	fmt.Println("User table create result:", result)
	if err != nil {
		return err
	}
	result, err = creteTasksTab(db)
	fmt.Println("Tasks table create result:", result)
	if err != nil {
		return err
	}
	result, err = creatUserTasksTab(db)
	fmt.Println("User-Tasks table create result:", result)
	if err != nil {
		return err
	}
	return nil
}
