@echo off
SetLocal EnableExtensions EnableDelayedExpansion

:: Obtener la ruta completa del archivo .bat
set "batch_dir=%~dp0"

:: Definir la ruta completa al archivo de lista donde se guardará la información
set list=%batch_dir%music_mapstart.txt

:: Eliminar cualquier archivo existente con el mismo nombre
2> NUL del "%list%"

:: Directorio base donde están las canciones
set "base_dir=C:\Program Files (x86)\Steam\steamapps\common\Left 4 Dead 2\left4dead2\"

:: Recorre todos los archivos .mp3 en el directorio donde se encuentra el .bat
for %%a in ("%batch_dir%*.mp3") do (
    :: Obtener la duración del archivo .mp3 (en formato hh:mm:ss.xx)
    for /f "tokens=2 delims= " %%b in ('ffmpeg -i "%%a" 2^>^&1 ^| findstr "Duration"') do (
        echo Duration found: %%b
        set "duration=%%b"
        :: Extraer las horas, minutos y segundos de la duración en formato hh:mm:ss.xx
        for /f "tokens=1-3 delims=:." %%c in ("!duration!") do (
            set /a "hours=%%c"
            set /a "minutes=%%d"
            set /a "seconds=%%e"
            :: Calcular la cantidad total de segundos (horas * 3600 + minutos * 60 + segundos)
            set /a "total_seconds=!hours! * 3600 + !minutes! * 60 + !seconds!"
            
            :: Obtener la ruta completa del archivo (como C:\ruta\de\musica\Break_Free.mp3)
            set "full_path=%%a"
            
            :: Eliminar la parte de la ruta base para dejar solo la ruta relativa
            set "relative_path=!full_path:%base_dir%=!"
            
            :: Obtener el nombre de la canción (sin la extensión .mp3)
            set "song_name=%%~na"
            
            :: Guardar la información en el archivo de lista en el formato deseado
            echo !relative_path! TAG- !song_name! - !total_seconds! >> "%list%"
        )
    )
)

echo File list with durations is successfully saved to: %list%
echo.
pause

goto :eof
