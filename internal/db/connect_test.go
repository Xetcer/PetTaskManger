package db

import (
	"testing"
)

/*
Предполагается что есть БД postgres и в ней есть пользователь postgres с паролем 5421
*/
func TestConnectDB(t *testing.T) {
	tests := []struct {
		name   string
		conStg PSQLConnectStg
		isErr  bool
	}{
		{name: "Sucsess connection", conStg: PSQLConnectStg{DbName: "postgres", User: "postgres", Password: "5421", Host: "localhost", SSL: "disable"}, isErr: false},
		{name: "Bad connection", conStg: PSQLConnectStg{DbName: "NONAME", User: "postgres", Password: "5421", Host: "localhost", SSL: "disable"}, isErr: true},
		{name: "Wrong password", conStg: PSQLConnectStg{DbName: "postgres", User: "postgres", Password: "0000", Host: "localhost", SSL: "disable"}, isErr: true},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			db, err := ConnectDB(test.conStg)
			got := err != nil
			if got != test.isErr {
				t.Errorf("ConnectDB() want %v, got %v.", test.isErr, got)
			}
			if db != nil {
				db.Close()
			}
		})
	}
}
