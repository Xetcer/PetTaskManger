/*
CRUD для работы с PSQL
*/
package db

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq" // Импортируем драйвер PostgreSQL
)

type PSQLConnectStg struct {
	DbName   string `json:"dbName"`
	User     string `json:"user"`
	Password string `json:"password"`
	Host     string `json:"host"`
	SSL      string `json:"SSL"`
}

// connectDB пробуем подключиться к БД, вернем указатель на базу данных и ошибку.
func ConnectDB(stg PSQLConnectStg) (*sql.DB, error) {
	connStr := fmt.Sprintf("user=%s password=%s dbname=%s host=%s sslmode=%s", stg.User, stg.Password, stg.DbName, stg.Host, stg.SSL)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, err
	}

	err = db.Ping()
	if err != nil {
		return nil, err
	}

	return db, nil
}
