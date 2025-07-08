#!/bin/bash

echo "🎉 ¡Bienvenido al Cuestionario Loco! 🎉"

# Pregunta 1
read -p "🤔 ¿Cuál es tu nombre?: " nombre

# Pregunta 2
read -p "📅 ¿Cuántos años tenés?: " edad

# Pregunta 3
read -p "🎨 ¿Cuál es tu color favorito?: " color

echo ""
echo "🧠 Procesando tus respuestas... 💭"
sleep 1

# Mensaje según edad
if [ "$edad" -lt 10 ]; then
    echo "👶 ¡$nombre, sos una criatura mágica en crecimiento! 🌱"
elif [ "$edad" -lt 20 ]; then
    echo "🔥 $nombre, estás en plena etapa rebelde del universo. ¡Aprovechala! 🤘"
elif [ "$edad" -lt 40 ]; then
    echo "💼 $nombre, seguramente dominás el mundo a tu manera 💪"
else
    echo "🧙 $nombre, tu sabiduría debe ser legendaria. ¡Compartila! 📚"
fi

# Mensaje según color favorito
if [[ "$color" == "rojo" || "$color" == "Rojo" ]]; then
    echo "💥 Rojo como un volcán enojado... ¡peligroso y apasionado!"
elif [[ "$color" == "azul" || "$color" == "Azul" ]]; then
    echo "🌊 Azul como el océano profundo. ¡Tranquilidad máxima!"
elif [[ "$color" == "verde" || "$color" == "Verde" ]]; then
    echo "🌿 Verde como la naturaleza loca después de la lluvia."
else
    echo "🎨 ¡$color es único! Como vos, $nombre 💫"
fi

echo ""
echo "✨ ¡Gracias por jugar con el Cuestionario Loco! ✨"
