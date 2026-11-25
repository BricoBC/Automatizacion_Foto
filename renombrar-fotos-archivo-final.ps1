function Invoke-RenombrarFotosArchivoFinal {
    Write-Host " ----------- SCRIPT DE RENOMBRADO DE FOTOS A NOMBRE FINAL ----------- " -ForegroundColor Cyan
    $rutaInput = Read-Host "Ingresa la ruta de la carpeta que quieres RENOMBRAR las imágenes"
    $ruta = $rutaInput.Trim()

    if ($ruta.Length -ge 2) {
        if (($ruta.StartsWith('"') -and $ruta.EndsWith('"')) -or
            ($ruta.StartsWith("'") -and $ruta.EndsWith("'"))) {
            $ruta = $ruta.Substring(1, $ruta.Length - 2).Trim()
        }
    }

    $ruta = [Environment]::ExpandEnvironmentVariables($ruta)

    if ([string]::IsNullOrWhiteSpace($ruta)) {
        Write-Host "No ingresaste ninguna ruta." -ForegroundColor Yellow
        return
    }

    if (-not (Test-Path -LiteralPath $ruta -PathType Container)) {
        Write-Host "La ruta no existe o no corresponde a una carpeta:" -ForegroundColor Red
        Write-Host $ruta -ForegroundColor Red
        return
    }

    $imagenes = Get-ChildItem -LiteralPath $ruta -File |
        Where-Object { $_.Extension -match '(?i)^\.(jpg|jpeg|png)$' }

    if ($imagenes.Count -eq 0) {
        Write-Host "No se encontraron imágenes JPG, JPEG o PNG en la carpeta." -ForegroundColor Yellow
        return
    }

    $prefijos = foreach ($imagen in $imagenes) {
        if ($imagen.Name -match '^(.+)-(\d+)\.[^.]+$') {
            $Matches[1]
        }
    }

    $prefijoActualSugerido = $prefijos | Select-Object -Unique | Select-Object -First 1

    if ([string]::IsNullOrWhiteSpace($prefijoActualSugerido)) {
        Write-Host "No se encontraron imágenes con la nomenclatura texto-número.ext." -ForegroundColor Yellow
        return
    }

    Write-Host "Prefijo actual detectado: $prefijoActualSugerido" -ForegroundColor Cyan

    $textoNuevoInput = Read-Host "Texto nuevo para el nombre"
    if ([string]::IsNullOrWhiteSpace($textoNuevoInput)) {
        Write-Host "El texto nuevo no puede estar vacío." -ForegroundColor Yellow
        return
    }

    $textoNuevo = $textoNuevoInput.Trim() -replace ' ', '_'

    $coincidencias = $imagenes | Where-Object {
        if ($_.Name -match '^(.+)-(\d+)\.[^.]+$') {
            $Matches[1] -eq $prefijoActualSugerido
        }
    } | Sort-Object {
        if ($_.Name -match '-(\d+)\.[^.]+$') { [int]$Matches[1] } else { 0 }
    }

    if ($coincidencias.Count -eq 0) {
        Write-Host "No se encontraron imágenes cuyo prefijo sea '$prefijoActualSugerido'." -ForegroundColor Yellow
        return
    }

    $errores = @()

    foreach ($imagen in $coincidencias) {
        if ($imagen.Name -match '^(.+)-(\d+)(\.[^.]+)$') {
            $nombreFinal = "$textoNuevo-$($Matches[2])$($Matches[3])"
            $rutaFinal = Join-Path -Path $ruta -ChildPath $nombreFinal

            if ([string]::Equals($imagen.Name, $nombreFinal, [System.StringComparison]::OrdinalIgnoreCase)) {
                continue
            }

            if (Test-Path -LiteralPath $rutaFinal) {
                $errores += "No se renombró '$($imagen.Name)': ya existe '$nombreFinal'."
            } else {
                Rename-Item -LiteralPath $imagen.FullName -NewName $nombreFinal
                Write-Host "Renombrado: $($imagen.Name) -> $nombreFinal" -ForegroundColor Green
            }
        }
    }

    if ($errores.Count -gt 0) {
        Write-Host "`nSe encontraron conflictos:" -ForegroundColor Red
        $errores | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    }

    Write-Host "`n¡Proceso terminado!" -ForegroundColor Yellow
}

function Main {
    Invoke-RenombrarFotosArchivoFinal
}

Main
