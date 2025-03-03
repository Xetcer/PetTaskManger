package db

import (
	"fmt"
	"testing"

	_ "github.com/lib/pq" // Импортируем драйвер PostgreSQL
	"github.com/stretchr/testify/require"
)

var tstConnectStg = PSQLConnectStg{DbName: "postgres", User: "postgres", Password: "5421", Host: "localhost", SSL: "disable"}

func TestCreateDB(t *testing.T) {
	tstDBName := "test_db_name"
	db, err := ConnectDB(tstConnectStg)
	if err != nil {
		t.Errorf("Failed to connect DB")
	}
	defer db.Close()
	db.Exec(fmt.Sprintf("DROP DATABASE %s;", tstDBName))
	tests := []struct {
		name  string
		isErr bool
	}{
		{name: "Sucsess creation", isErr: false},
		{name: "Failed creation", isErr: true},
	}

	for _, test := range tests {
		// t.Run(test.name, func(t *testing.T) {
		err := CreateDB(db, tstDBName)
		got := err != nil
		if got != test.isErr {
			t.Errorf("CreateDB() want %v, got %v.", test.isErr, got)
			fmt.Println(err)
		}
		// })
	}
	db.Exec("DROP DATABASE test_db_name;")
}

// Тестовая функция для проверки создания таблицы users
func TestCreateUsersTab(t *testing.T) {
	// Открываем тестовое соединение с базой данных
	db, err := ConnectDB(tstConnectStg)
	require.NoError(t, err)
	defer db.Close()

	// Создаём таблицу users
	_, err = createUsersTab(db)
	require.NoError(t, err)

	// Проверяем, что таблица создана
	rows, err := db.Query("SELECT COUNT(*) FROM pg_class WHERE relname='users'")
	require.NoError(t, err)
	defer rows.Close()

	var count int
	require.True(t, rows.Next())
	require.NoError(t, rows.Scan(&count))
	require.Equal(t, 1, count)

	// Чистим таблицу после теста
	_, err = db.Exec("DROP TABLE users;")
	require.NoError(t, err)
}

// Тестовая функция для проверки создания таблицы tasks
func TestCreteTasksTab(t *testing.T) {
	// Открываем тестовое соединение с базой данных
	db, err := ConnectDB(tstConnectStg)
	require.NoError(t, err)
	defer db.Close()

	// Создаём таблицу tasks
	_, err = creteTasksTab(db)
	require.NoError(t, err)

	// Проверяем, что таблица создана
	rows, err := db.Query("SELECT COUNT(*) FROM pg_class WHERE relname='tasks'")
	require.NoError(t, err)
	defer rows.Close()

	var count int
	require.True(t, rows.Next())
	require.NoError(t, rows.Scan(&count))
	require.Equal(t, 1, count)

	// Чистим таблицу после теста
	_, err = db.Exec("DROP TABLE tasks;")
	require.NoError(t, err)

	_, err = dropTypes(db)
	require.NoError(t, err)
}

// Тестовая функция для проверки создания таблицы user_tasks
func TestCreatUserTasksTab(t *testing.T) {
	// Открываем тестовое соединение с базой данных
	db, err := ConnectDB(tstConnectStg)
	require.NoError(t, err)
	defer db.Close()

	// Создаём таблицу user_tasks
	_, err = creatUserTasksTab(db)
	require.NoError(t, err)

	// Проверяем, что таблица создана
	rows, err := db.Query("SELECT COUNT(*) FROM pg_class WHERE relname='user_tasks'")
	require.NoError(t, err)
	defer rows.Close()

	var count int
	require.True(t, rows.Next())
	require.NoError(t, rows.Scan(&count))
	require.Equal(t, 1, count)

	// Чистим таблицу после теста
	_, err = db.Exec("DROP TABLE user_tasks;")
	require.NoError(t, err)
}

// Тестовая функция для проверки функции CreateTables
func TestCreateTables(t *testing.T) {
	// Открываем тестовое соединение с базой данных
	db, err := ConnectDB(tstConnectStg)
	require.NoError(t, err)
	defer db.Close()

	// Выполняем функцию CreateTables
	err = CreateTables(db)
	require.NoError(t, err)

	// Проверяем, что все три таблицы созданы
	rows, err := db.Query("SELECT COUNT(*) FROM pg_class WHERE relname IN ('users', 'tasks', 'user_tasks')")
	require.NoError(t, err)
	defer rows.Close()

	var count int
	require.True(t, rows.Next())
	require.NoError(t, rows.Scan(&count))
	require.Equal(t, 3, count)

	// Чистим все таблицы после теста
	_, err = db.Exec("DROP TABLE users, tasks, user_tasks;")
	require.NoError(t, err)

	_, err = dropTypes(db)
	require.NoError(t, err)
}
