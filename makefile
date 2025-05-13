# Цель по умолчанию
SHELL := cmd

.PHONY: help
help:
	@echo "Available targets:"
	@echo "temp - create temp directory"
	@echo "goose_install - install goose migration tool"
	@echo "docker_build_image - build image with tasks_db"

#Переменные окружения 
# параметры базы данных
POSTGRES_PASSWORD ?=5421

#Переменные goose
GOOSE_DRIVER ?=postgres
GOOSE_DBSTRING ?="user=postgres password=5421 dbname=tasks_db sslmode=disable"
GOOSE_MIGRATION_DIR ?=internal/db/migrations

#Переменные для docker
DOCKER_IMAGE_NAME := my_psql:1
DOCKER_FILE_PATH :=internal\db\docker

# 1. Создаем директорию temp/psql/pgdata для подключения volume docker
temp: 
	mkdir temp\psql\pgdata\

# 2. установить GOOSE
goose_install: 
	go install github.com/pressly/goose/v3/cmd/goose@latest

#docker команды
#собрать образ по докерфайлу
docker_build_image:
	@echo off
	echo Building Docker image...
	docker build -t $(DOCKER_IMAGE_NAME) -f $(DOCKER_FILE_PATH)\dockerfile .
	@if ERRORLEVEL 1 echo Error creating image $(DOCKER_IMAGE_NAME). else\
	echo Image $(DOCKER_IMAGE_NAME) created!

#первый запуск контейнера
docker_first_run_container:


