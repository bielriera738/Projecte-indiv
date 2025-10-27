from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Usuario(BaseModel):
    peso: float
    altura: float
    edad: int
    sexo: str
    actividad: str

# Fórmula de Harris-Benedict
def calcular_tmb(peso, altura, edad, sexo):
    if sexo.lower() == "hombre":
        return 88.362 + (13.397 * peso) + (4.799 * altura) - (5.677 * edad)
    else:
        return 447.593 + (9.247 * peso) + (3.098 * altura) - (4.330 * edad)

factores = {
    "sedentario": 1.2,
    "ligero": 1.375,
    "moderado": 1.55,
    "intenso": 1.725
}

@app.post("/calcular/")
def calcular_macros(user: Usuario):
    tmb = calcular_tmb(user.peso, user.altura, user.edad, user.sexo)
    factor = factores.get(user.actividad.lower(), 1.2)
    calorias = tmb * factor

    proteinas = round((calorias * 0.20) / 4, 2)
    carbohidratos = round((calorias * 0.50) / 4, 2)
    grasas = round((calorias * 0.30) / 9, 2)

    # 👉 Generamos la respuesta automática en texto
    mensaje = (
        f"Según tus datos ({user.peso} kg, {user.altura} cm, {user.edad} años, {user.sexo}, "
        f"actividad {user.actividad}), tu ingesta recomendada es:\n\n"
        f"🔹 Calorías: {round(calorias,2)} kcal\n"
        f"🍗 Proteínas: {proteinas} g\n"
        f"🥖 Carbohidratos: {carbohidratos} g\n"
        f"🥑 Grasas: {grasas} g\n\n"
        "👉 Recuerda que estos valores son estimados y pueden variar según tu objetivo (definición, volumen o mantenimiento)."
    )

    return {"mensaje": mensaje}
