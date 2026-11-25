Write-Host " ----------- SCRIPT PARA ASIGNAR NOMBRE FINAL A FOTOS ----------- " -ForegroundColor Cyan

do {
    # Solicitar la ruta de la carpeta al usuario
    $ruta = Read-Host "Ingresa la ruta de la carpeta con las fotos"

    # Validar que la ruta exista
    if (-not (Test-Path $ruta)) {
        Write-Error "La ruta especificada no existe."
    } else {

        # Obtener el nombre de la carpeta, ignorar números y separadores al inicio y reemplazar espacios por guiones
        $nombreCarpetaLimpio = (Split-Path -Path $ruta -Leaf) -replace '^\d+[-_.\s]*', '' -replace ' ', '-'

        $prefijoInput = Read-Host "Introduce el prefijo para las fotos [Por defecto: $nombreCarpetaLimpio]"
        # Si el usuario presiona Enter sin escribir nada, usa el nombre de la carpeta formateado
        $prefijo = if ([string]::IsNullOrWhiteSpace($prefijoInput)) {
            $nombreCarpetaLimpio
        } else {
        $prefijoInput.Trim() -replace ' ', '_'
        }

        $numeroInput = Read-Host "Introduce el número con el que deseas empezar [Por defecto: 1]"
        # Si el usuario presiona Enter sin escribir nada, usa 1
        $inicioNumero = if ([string]::IsNullOrWhiteSpace($numeroInput)) { 1 } else { [int]$numeroInput }

        # 2. Obtener todas las fotos que cumplan con el patrón "número-nombre"
        # Las filtramos y ordenamos numéricamente según su número original para no perder el orden
        $imagenes = Get-ChildItem -Path $ruta -File | 
            Where-Object { $_.Extension -match '\.(jpg|jpeg|png)$' -and $_.Name -match '^(\d+)-' } |
            Sort-Object { [int]($_.Name -split '-')[0] }

        if ($imagenes.Count -eq 0) {
            Write-Host "No se encontraron fotos que empiecen con un número y guion (ej. 1-foto.jpg/jpeg/png) en esa carpeta." -ForegroundColor Yellow
            exit
        }

        # 3. Determinar la cantidad de dígitos según el total de imágenes encontradas
        if ($imagenes.Count -lt 80) {
            $digitosInput = Read-Host "Se encontraron $($imagenes.Count) fotos (menos de 80). Introduce la cantidad de dígitos [Por defecto: 3]"
            $digitos = if ([string]::IsNullOrWhiteSpace($digitosInput)) { 3 } else { [int]$digitosInput }
        } else {
            $digitos = 3
            Write-Host "`nSe encontraron $($imagenes.Count) fotos (80 o más). Se aplicarán 3 dígitos automáticamente." -ForegroundColor Gray
        }

        Write-Host "`nProcesando y renombrando archivos con $digitos dígitos..." -ForegroundColor Cyan
        $contador = $inicioNumero

        # 4. Recorrer cada imagen y renombrarla secuencialmente
        foreach ($imagen in $imagenes) {
            $extension = $imagen.Extension # Conserva la extensión original (.jpg, .png...)
            
            # Formatear el número con los ceros iniciales calculados
            $numeroFormateado = $contador.ToString("D$digitos")
            
            # Construir el nuevo nombre limpio usando las variables
            $nuevoNombre = "$prefijo-$numeroFormateado$extension"
            
            # Renombrar el archivo
            Rename-Item -Path $imagen.FullName -NewName $nuevoNombre
            Write-Host "Renombrado: $($imagen.Name) -> $nuevoNombre" -ForegroundColor Green
            
            # Incrementar el número para la siguiente foto
            $contador++
        }

        Write-Host "`n¡Proceso terminado con éxito!" -ForegroundColor Yellow
    }

    $fix_name = Read-Host "¿Deseas renombrar las fotos a un nombre final específico? (s/N)"
    if ($fix_name -eq 's' -or $fix_name -eq 'S') {
        # Llamar al script renombrar-fotos-archivo-final.ps1
        & "$PSScriptRoot\renombrar-fotos-archivo-final.ps1" -ruta $ruta
    }
    
    Write-Host "--------------------------------------------------"
    # Pregunta de repetición (Por defecto es 'n' si solo presionan Enter)
    $respuesta = Read-Host "¿Deseas volver a ejecutar el script con otra ruta? (s/N)"
    
    if ([string]::IsNullOrWhiteSpace($respuesta)) {
        $respuesta = "n"
    }

} while ($respuesta -eq 's' -or $respuesta -eq 'S')

Write-Host "Saliendo del programa. ¡Hasta luego!" -ForegroundColor DarkGray
Start-Sleep -Seconds 1