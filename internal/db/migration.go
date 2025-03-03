package db

import (
	"database/sql"
	"fmt"
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
