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
DOCKER_FILE_PATH := internal\db\docker
CONTAINER_NAME := psql-container
VOLUME_NAME := E:\myWork\Study\GoLang\go\src\pettaskmngr\tmp\psql\pgdata
PORT_BINDING := 5432:5432
ENV_FILE := dbconfig.env

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
docker_first_run_container: docker_check_directory docker_check_env docker_container_start

# Проверяем, существует ли директория и создаем её, если нет
docker_check_directory:
	@if not exist $(VOLUME_NAME) (mkdir $(VOLUME_NAME) echo "Directory '$(VOLUME_NAME)' created.")\
	else (echo "Directory '$(VOLUME_NAME)' already exists.")

# Проверяем, существует ли файл .env
docker_check_env:
	@if not exist $(ENV_FILE) (echo "Warning: The .env file does not exist at '$(ENV_FILE)'. The container may not start correctly." \
	echo "Container will not be started due to missing .env file." exit 1)
 
 # Запускаем контейнер Docker
docker_container_start:
	@echo Starting Docker container...
	@docker run -v "$(VOLUME_NAME):/var/lib/postgresql/data" -p $(PORT_BINDING) --name $(CONTAINER_NAME) --env-file "$(ENV_FILE)" -d $(DOCKER_IMAGE_NAME)
	@if not %ERRORLEVEL%==0 (echo Error occurred while starting the container.\
	echo Docker logs for $(CONTAINER_NAME):\
	docker logs $(CONTAINER_NAME)\
	) else (\
	echo Container '$(CONTAINER_NAME)' has been successfully started!\
	)

