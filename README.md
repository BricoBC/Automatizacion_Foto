# Automatizacion_Foto

Script de PowerShell para Windows que renombra fotografías que fueron descargadas con la aplicación de lightroom a una carpeta utilizando un prefijo personalizado y una numeración secuencial.

## Qué hace el script

El script:

- Busca archivos con extensión `.jpg`, `.jpeg`, `.png` o `.webp`.
- Solo procesa imágenes cuyo nombre comienza con un número seguido de un guion, por ejemplo `1-foto.jpg` o `24-foto.png`. Por defecto esta es la nomenclatura a la hora de descargar las fotos en lightroom.
- Ordena las imágenes por su número original.
- Las renombra con un prefijo y números con ceros a la izquierda.

Ejemplo:

```text
Antes:
1-foto.jpg
2-foto.jpg
3-foto.jpg

Después:
Jardin-norte-001.jpg
Jardin-norte-002.jpg
Jardin-norte-003.jpg
```

## Requisitos

- Windows 10 u Windows 11.
- PowerShell 5.1 o PowerShell 7.
- Los nombres originales deben comenzar con un número y un guion.
- Se recomienda hacer una copia de seguridad de las fotografías antes de ejecutar el script.

## Descargar el proyecto

1. Abre el repositorio en GitHub.
2. Haz clic en **Code**.
3. Selecciona **Download ZIP**.
4. Extrae el archivo ZIP en una carpeta de tu equipo, por ejemplo:

```text
C:\Users\TuUsuario\Fotos
```

El script estará dentro de la carpeta extraída con el nombre `renombrar-fotos-camara-a-nombre-final.ps1`.

## Ejecutar el script

### Método recomendado

1. Coloca las fotografías que deseas renombrar en una carpeta.
2. Haz clic derecho en el Explorador de archivos sobre el fondo de la carpeta donde está el script.
3. Selecciona **Abrir en Terminal** o **Abrir ventana de PowerShell aquí**.
4. Ejecuta:

```powershell
.\renombrar-fotos-camara-a-nombre-final.ps1
```

Si Windows bloquea la ejecución de scripts descargados, abre PowerShell como usuario normal y ejecuta primero:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Después ejecuta otra vez:

```powershell
.\renombrar-fotos-camara-a-nombre-final.ps1
```

Esta configuración solo afecta a la sesión actual de PowerShell y no modifica permanentemente el equipo.

### Otra opción

También puedes iniciar PowerShell y escribir la ruta del script entre comillas:

```powershell
& "C:\Users\TuUsuario\Fotos\renombrar-fotos-camara-a-nombre-final.ps1"
```

## Datos solicitados por el script

Al iniciar, el programa solicita los siguientes datos:

### 1. Ruta de la carpeta

Escribe la ruta completa que contiene las fotografías.

Ejemplo:

```text
C:\Users\TuUsuario\Pictures\Sesion-fotos
```

La ruta debe existir antes de continuar.

### 2. Prefijo

Este texto aparecerá al inicio de cada nuevo nombre.

- Si presionas **Enter** sin escribir, se utilizará el nombre de la carpeta.
- Los números iniciales del nombre de la carpeta se eliminarán.
- Los espacios se cambiarán por guiones.
- Si escribes un prefijo manualmente, los espacios se cambiarán por guiones bajos.

Ejemplo con una carpeta llamada `23-Jardin norte`:

```text
Prefijo predeterminado: Jardin-norte
Resultado en el nombre de las fotografías: Jardin-norte-001.jpg
```

### 3. Número inicial

Indica por cuál número debe comenzar la numeración.

- Si presionas **Enter** sin escribir, comenzará desde `1`.

Ejemplo:

```text
101
102
103
```

### 4. Cantidad de dígitos

Si la carpeta tiene menos de 80 fotografías, el script permite elegir cuántos dígitos tendrá el número.

- Si presionas **Enter** sin escribir, se utilizarán `3` dígitos.
- `001`, `002` y `003` son ejemplos con tres dígitos.
- Con `4` dígitos se generaría `0001`, `0002`, etc.

Si hay 80 fotografías o más, el script usa automáticamente tres dígitos.

## Antes de renombrar

Los archivos originales deben seguir el formato:

```text
<número>-<cualquier texto>.<extensión>
```

Ejemplos válidos:

```text
1-foto.jpg
12-paisaje.png
23-mi-foto.webp
```

Archivos que no sean fotografías o cuyos nombres no comiencen con un número seguido de un guion no serán modificados.

El script conserva la extensión original de cada archivo.

## Resultado esperado

Por ejemplo, con estas imágenes:

```text
10-playa.jpg
2-playa.jpg
21-playa.jpg
```

Se ordenarán numéricamente y pueden convertirse en:

```text
Playa-001.jpg
Playa-002.jpg
Playa-003.jpg
```

Cada vez que finaliza un archivo, el script muestra el cambio realizado en la terminal.

## Precauciones

- Realiza una copia antes de procesar fotografías importantes.
- Evita ejecutar el script dentro de una carpeta que ya contenga nombres finales como `Jardin-norte-001.jpg`, porque las fotografías podrían dejar de cumplir el patrón de origen y no procesarse.
- Si dos archivos generan el mismo nombre, Windows puede rechazar o alterar el cambio. Usa prefijos y números iniciales que no coincidan con nombres existentes.
- El script modifica los nombres directamente; no crea copias y no incluye una función para deshacer el cambio.
- No incluye subcarpetas: solo procesa los archivos directamente dentro de la carpeta indicada.