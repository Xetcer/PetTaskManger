@echo off
setlocal
::cd /d "%~dp0"

:: Параметры
set DOCKER_IMAGE_NAME=my_psql:1
set CONTAINER_NAME=psql-container
:: хранилище всегда указывать абсолютный путь в конце не должно быть пробелов!!!
set VOLUME_NAME=E:\myWork\Study\GoLang\go\src\pettaskmngr\tmp\psql\pgdata
set PORT_BINDING=5432:5432
:: тут можно указывать относительный путь!
set ENV_FILE=E:\myWork\Study\GoLang\go\src\pettaskmngr\dbconfig.env

:: Отладочные сообщения
echo CD: %cd%
echo Path to .env file: %ENV_FILE%

:: Check if the script is run as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Run this script as an administrator.
    pause
    exit /b
)

:: Check if the directory exists and create it if not
if not exist "%VOLUME_NAME%" (
    mkdir "%VOLUME_NAME%"
    echo Directory "%VOLUME_NAME%" created.
) else (
    echo Directory "%VOLUME_NAME%" already exists.
)

:: Check if the .env file exists
if not exist "%ENV_FILE%" (
    echo Warning: The .env file does not exist at "%ENV_FILE%". The container may not start correctly.
    echo Container will not be started due to missing .env file.
    pause
    exit /b
)

echo Creating and starting container...

:: Start the container and output any error directly to the console
docker run -v "%VOLUME_NAME%:/var/lib/postgresql/data" -p %PORT_BINDING% --name %CONTAINER_NAME% --env-file "%ENV_FILE%" -d %DOCKER_IMAGE_NAME%
echo docker run -v "%VOLUME_NAME%:/var/lib/postgresql/data" -p %PORT_BINDING% --name %CONTAINER_NAME% --env-file "%ENV_FILE%" -d %DOCKER_IMAGE_NAME%
if %errorlevel% neq 0 (
    echo An error occurred while starting the container.
    echo Docker error output:
    docker logs %CONTAINER_NAME%
) else (
    echo Container "%CONTAINER_NAME%" has been successfully started!
)

endlocal
pause
