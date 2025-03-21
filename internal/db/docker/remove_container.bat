@echo off
setlocal

:: Переменные
set CONTAINER_NAME=psql-container

:: Сообщение о запуске контейнера
echo Remove container...

:: остановка контейнера контейнера
docker container rm %CONTAINER_NAME%

:: Проверка успешности выполнения команды
if %errorlevel% neq 0 (
    echo Container remove error %CONTAINER_NAME%!
    pause
    exit /b %errorlevel%
)

:: Сообщение об успешном запуске контейнера
echo container '%CONTAINER_NAME%' removed!

endlocal
pause
