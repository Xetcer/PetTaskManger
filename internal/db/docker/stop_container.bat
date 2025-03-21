@echo off
setlocal

:: Переменные
set CONTAINER_NAME=psql-container

:: Сообщение о запуске контейнера
echo Stop container...

:: остановка контейнера контейнера
docker container stop %CONTAINER_NAME%

:: Проверка успешности выполнения команды
if %errorlevel% neq 0 (
    echo Container stop error %CONTAINER_NAME%!
    pause
    exit /b %errorlevel%
)

:: Сообщение об успешном запуске контейнера
echo container '%CONTAINER_NAME%' stoped!

endlocal
pause
