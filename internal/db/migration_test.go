package db

import (
	"fmt"
	"testing"
)

func TestCreateDB(t *testing.T) {
	conStg := PSQLConnectStg{DbName: "postgres", User: "postgres", Password: "5421", Host: "localhost", SSL: "disable"}
	tstDBName := "test_db_name"
	db, err := ConnectDB(conStg)
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
