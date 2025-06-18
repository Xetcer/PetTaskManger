# Цель по умолчанию
SHELL := cmd

.PHONY: help
help:
	@echo "Available targets:"
	@echo "build_pet - build pet project"
	@echo "delete_pet - goose_down, stop DB, remove contaier, clean volume directory"
	@echo "temp - create temp directory"
	@echo "goose_install - install goose migration tool"
	@echo "docker_build_image - build image with tasks_db"
	@echo "docker_first_run_container - first start container with image"
	@echo "docker_stop_container - stop container"
	@echo "docker_restart_container - restart container"
	@echo "docker_remove_container - remove container"
	@echo "goose_up - migrate db to psql db in docker contaier"
	@echo "goose_down - remove db from psql db in docker contaier"



# Развернуть все с 0
.PHONY: build_pet 
build_pet: temp goose_install docker_build_image docker_first_run_container 

#удалить все
.PHONY: delete_pet
delete_pet: goose_down docker_stop_container docker_remove_container clean

#Переменные окружения 
# параметры базы данных
POSTGRES_PASSWORD ?=5421

#Переменные goose
GOOSE_DRIVER ?=postgres
GOOSE_DBSTRING ?="user=postgres password=5421 dbname=tasks_db host=localhost port=5432 sslmode=disable"
GOOSE_MIGRATION_DIR ?=internal/db/migrations

#Переменные для docker
DOCKER_IMAGE_NAME := my_psql:1
DOCKER_FILE_PATH := internal\db\docker
CONTAINER_NAME := psql-container
VOLUME_NAME := E:\myWork\Study\GoLang\go\src\pettaskmngr\tmp\psql\pgdata
PORT_BINDING := 5432:5432
ENV_FILE := dbconfig.env


#Переменные для psql
USER := postgres
PASSWORD := 5421
DB_NAME := tasks_db

# 1. Создаем директорию temp/psql/pgdata для подключения volume docker
temp:
	@echo Creating temp directory for docker volume...
	@if not exist "$(VOLUME_NAME)" (mkdir "$(VOLUME_NAME)" && echo directory created)\
	else (echo Directory already exists.)
clean:
	@echo Removing temp directory $(VOLUME_NAME)...
	@if exist "$(VOLUME_NAME)" (rmdir /s /q "$(VOLUME_NAME)" && echo directory removed)
# 2. установить GOOSE
goose_install: 
	go install github.com/pressly/goose/v3/cmd/goose@latest

# Развернуть таблицы в БД
goose_up:
	goose -dir $(GOOSE_MIGRATION_DIR) $(GOOSE_DRIVER) $(GOOSE_DBSTRING) up

#удалить таблицы в БД
goose_down:
	goose -dir $(GOOSE_MIGRATION_DIR) $(GOOSE_DRIVER) $(GOOSE_DBSTRING) down

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
 
# Запускаем контейнер Docker с параметрами
docker_container_start:
	@echo Starting Docker container...
	docker run -v "$(VOLUME_NAME):/var/lib/postgresql/data" -p $(PORT_BINDING) --name $(CONTAINER_NAME) --env-file "$(ENV_FILE)" -d $(DOCKER_IMAGE_NAME)
	@if ERRORLEVEL 1 ( \
	echo Error occurred while starting the container. \
	docker logs $(CONTAINER_NAME); \
	) else ( \
	echo Container '$(CONTAINER_NAME)' has been successfully started!; \
	)

# Остановить запущенный контейнер
docker_stop_container:
	@echo Stop container...
	docker container stop $(CONTAINER_NAME)
	@if ERRORLEVEL 1 ( \
		echo Error container stop $(CONTAINER_NAME)! \
	) else ( \
		echo container $(CONTAINER_NAME) stoped!\
	)

# Перезапустить созданный контейнер
docker_restart_container:
	@echo Starting container...
	docker start $(CONTAINER_NAME)
	@if ERRORLEVEL 1 ( \
		echo Error container staring $(CONTAINER_NAME)! \
	) else ( \
		echo container $(CONTAINER_NAME) started!\
	)

# Удалить созданный контейнер
docker_remove_container:
	@echo Remove container...
	docker container rm $(CONTAINER_NAME)
	@if ERRORLEVEL 1 ( \
		echo Error container remove $(CONTAINER_NAME)! \
	) else ( \
		echo container $(CONTAINER_NAME) removed!\
	)

# Подключиться к psql в контейнере для отладки
docker_connect_psql:
	docker exec -it $(CONTAINER_NAME) psql -U $(USER) $(DB_NAME)
