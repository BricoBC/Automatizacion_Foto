# Automatizacion_Foto

Colección de scripts de PowerShell para Windows que renombra fotografías de manera automática.

## Scripts disponibles

| Script | Para qué sirve |
|---|---|
| `renombrar-fotos-camara-a-nombre-final.ps1` | Convierte nombres que comienzan por un número, como `1-foto.jpg`, en nombres numerados con un prefijo. |
| `renombrar-fotos-archivo-final.ps1` | Cambia solamente el prefijo de nombres que ya tienen formato `texto-número.jpg`, como `Jardin-norte-001.jpg`. |

Ambos scripts funcionan directamente sobre los archivos de una carpeta y no crean copias.

## Requisitos

- Windows 10 u Windows 11.
- PowerShell 5.1 o PowerShell 7.
- Una carpeta existente con las fotografías.
- Se recomienda crear una copia de seguridad antes de renombrar fotografías importantes.

## Descargar el proyecto

1. Abre el repositorio en GitHub.
2. Haz clic en **Code**.
3. Selecciona **Download ZIP**.
4. Extrae el archivo ZIP en una ubicación de tu equipo.

## Ejecutar un script

Haz clic derecho sobre la carpeta donde estén los scripts y selecciona **Abrir en Terminal** o **Abrir ventana de PowerShell aquí**.

Si Windows bloquea los scripts descargados, puedes permitirlos temporalmente en la sesión actual:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Esta configuración solo afecta a la terminal actual y se revierte al cerrarla.

---

# Script 1: renombrar fotos de cámara

Archivo:

```text
renombrar-fotos-camara-a-nombre-final.ps1
```

## Qué hace

Busca imágenes `.jpg`, `.jpeg`, `.png` o `.webp` cuyos nombres comiencen con un número y un guion. Esta nomenclatura del nombre es la que te genera Lightroom.

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

## Uso

Ejecuta:

```powershell
.\renombrar-fotos-camara-a-nombre-final.ps1
```

El script solicitará:

1. **Ruta de la carpeta:** puede introducirse sin comillas o entre comillas.
2. **Prefijo:** presiona Enter para usar el nombre limpio de la carpeta.
3. **Número inicial:** presiona Enter para comenzar desde `1`.
4. **Cantidad de dígitos:** presiona Enter para usar `3` si existen menos de 80 imágenes.

Si hay 80 imágenes o más, el script usa automáticamente tres dígitos. Lo máximo que se comparten como imagenenes con el mismo nombre son 999, si quieres compartir más de 1,000 fotos se recomienda seccionar por sucesos las fotos. Por ejemplo, carpeta Iglesia, Batucada, etc. 

---

# Script 2: cambiar el prefijo del nombre final

Archivo:

```text
renombrar-fotos-archivo-final.ps1
```

## Qué hace

Este script cambia el texto anterior al número final sin modificar el número ni la extensión.

Busca imágenes `.jpg`, `.jpeg` y `.png` que tengan nombres con el formato:

```text
texto-número.extensión
```

Ejemplo:

```text
Antes:
Jardin-norte-001.jpg
Jardin-norte-002.jpg
Jardin-norte-003.jpg

Después:
Playa-001.jpg
Playa-002.jpg
Playa-003.jpg
```

## Uso

Ejecuta:

```powershell
.\renombrar-fotos-archivo-final.ps1
```

Aparecerá un encabezado y el script solicitará dos datos.

### 1. Ruta de la carpeta

Escribe la ruta completa de la carpeta que contiene las fotografías:

```text
C:\Users\usuario\Pictures\Mis fotos
```

También puedes escribirla entre comillas:

```text
"C:\Users\usuario\Pictures\Mis fotos"
```

El script:

- Elimina las comillas exteriores si las incluiste.
- Expande variables de entorno de Windows como `%USERPROFILE%`.
- Comprueba que la ruta exista y sea una carpeta.
- Muestra un mensaje cuando la ruta está vacía o no es válida.

Ejemplo con una variable de entorno:

```text
%USERPROFILE%\Pictures\Mis fotos
```

### 2. Texto nuevo

Introduce el texto que reemplazará al prefijo detectado:

```text
Playa verano
```

Los espacios se reemplazan por guiones bajos:

```text
Playa_verano-001.jpg
```

El texto no puede estar vacío.

## Qué nombres procesa

Ejemplos compatibles:

```text
Jardin-norte-001.jpg
Playa_verano-12.jpeg
Producto azul-4.png
```

Ejemplos no compatibles:

```text
001-foto.jpg
foto.jpg
foto-final-a.jpg
```

El script conserva el número y la extensión originales.

## Resultados

Durante la ejecución se muestra:

- El prefijo que detectó.
- El nombre de cada archivo renombrado.
- Los archivos que no pudo renombrar por un conflicto.
- Un mensaje final indicando que el proceso terminó.

Si el número de una imagen ya existe con el nuevo prefijo, el script no reemplaza el archivo existente. Ejemplo:

```text
No se renombró 'Jardin-norte-001.jpg': ya existe 'Playa-001.jpg'.
```

Si el nombre nuevo coincide exactamente con el nombre antiguo, el archivo se omite sin modificarlo.

## Ejemplo completo

Con una carpeta que contiene:

```text
Jardin-norte-001.jpg
Jardin-norte-002.jpg
Jardin-norte-003.png
```

Ingresa:

```text
Ruta: C:\Fotos\Sesion
Texto nuevo: Playa verano
```

El resultado será:

```text
Playa_verano-001.jpg
Playa_verano-002.jpg
Playa_verano-003.png
```

## Limitaciones

- Solo procesa `.jpg`, `.jpeg` y `.png`.
- No procesa subcarpetas.
- Solo modifica el prefijo detectado primero.
- No crea copias de las imágenes.
- No permite deshacer los cambios.
- No reemplaza archivos cuyo nombre de destino ya existe.

## Precauciones

- Haz una copia de las fotografías antes de ejecutar cualquier script.
- Comprueba que los nombres tengan el formato esperado.
- Comprueba la carpeta antes de continuar si contiene archivos con nombres similares.
- Revisa los resultados después de ejecutar el script.
