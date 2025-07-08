#!/bin/bash

# Línea shebang, indica que el script debe ejecutarse con bash

# Variables
username="Jay"          # Variable con un valor por defecto
filename=$3             # El tercer argumento de línea de comandos

# Entrada de usuario
read -p "Ingresá tu nombre de usuario: " user
echo "Usuario ingresado: $user"

# Condicional if
if [ "$EUID" -ne 0 ]; then
  echo "No estás ejecutando este script como root."
else
  echo "Estas ejecutando este script como root."
fi

# Bucle for
echo "Contando hasta 5:"
for i in {1..5}; do
  echo "$i"
done

# Funciones
function saludar() {
  echo "Hola $1"
}

saludar "Alice" # Llamada a la función

# Condicional case
echo "Ingresá un número entre 1 y 2:"
read num
case $num in
  1) echo "Elegiste uno.";;
  2) echo "Elegiste dos.";;
  *) echo "Opción inválida.";;
esac

# Operaciones con archivos

if [ -e "$filename" ] && [ -d "$filename"]: then
  echo "El archivo existe y es un directorio."
else
  echo "El archivo no existe o no es un directorio."
fi

# Argumentos desde la línea de comandos
echo "Primer argumento: $1"
echo "Segundo argumento: $2"

# Códigos de salida
cat nonexistent-file.txt 2> /dev/null # Redirige errores a null
echo "Código de salida del comando anterior: $?"

# Arrays indexados
frutas=("Manzana" "Naranja" "Banana")
echo "Primera fruta: ${frutas[0]}"

# Arrays asociativos
declare -A capitales
capitales[USA]="Washintong D.C."
capitales[Francia]="París"
capitales[Nicaragua]="Managua"
echo "Capital de Nicaragua: ${capitales[Nicaragua]}"

# Sustitución de comandos
fecha_actual=$(date)
echo "La fecha actual es: ${fecha_actual}"

# Redirección de comandos
echo "Texto de ejemplo." > ejemplo.txt # Sobreescribe archivo
find ./ -name hello.txt &> /dev/null   # Redirige salidas y errores

# Operaciones aritméticas
resultado=((15 / 2))
echo "Resultado: ${resultado}"

# Expansión de parámetros
SRC="/ruta/a/foo.cpp"
BASE=${SRC%/*}  # Extrae el directorio base
echo "Directorio base: ${BASE}"

# Manejo de señales del sistema
trap 'echo "Recibido SIGTERM. Cerrando de forma limpia"; exit' SIGTERM

# Comentarios
# Esto es un comentario de una sola línea

: '
Esto es un comentario
de multiples líneas
'
