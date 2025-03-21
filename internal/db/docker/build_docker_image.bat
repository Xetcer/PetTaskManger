@echo off
setlocal

:: Параметры
set DOCKER_IMAGE_NAME=my_psql:1
set DOCKERFILE_PATH=.\dockerfile

:: Сообщение о начале сборки
echo Building Docker image...

:: Сборка Docker-образа
docker build -t %DOCKER_IMAGE_NAME% -f %DOCKERFILE_PATH% .

:: Проверка успешности выполнения команды
if %errorlevel% neq 0 (
    echo Creting image error %DOCKER_IMAGE_NAME%.
    exit /b %errorlevel%
)

:: Сообщение об успешной сборке
echo Image %DOCKER_IMAGE_NAME% created!

endlocal
pause
