@echo off
setlocal

:: Переменные
set CONTAINER_NAME=psql-container

:: Сообщение о запуске контейнера
echo Starting container...

:: Запуск контейнера
docker start %CONTAINER_NAME%

:: Проверка успешности выполнения команды
if %errorlevel% neq 0 (
    echo Container start error %CONTAINER_NAME%!
    pause
    exit /b %errorlevel%
)

:: Сообщение об успешном запуске контейнера
echo container '%CONTAINER_NAME%' started!

endlocal
pause
