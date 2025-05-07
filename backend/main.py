from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import spacy
import requests
import os
import random
from dotenv import load_dotenv
from deep_translator import GoogleTranslator
from translate import Translator


# Cargar variables de entorno desde el archivo .env
load_dotenv()

# Cargar modelo spaCy para español
nlp = spacy.load("es_core_news_sm")

# Inicializar FastAPI
app = FastAPI()

# Configuración de CORS para aceptar peticiones desde cualquier frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Diccionario de palabras clave asociadas a tipos de dieta
diet_keywords_es = {
    'alta_proteina': ['proteina', 'alta en proteínas', 'mucha proteína', 'hiperproteica'],
    'ayuno_intermitente': ['ayuno intermitente', '16/8', 'ayuno', 'ayunar', '18/6', '12 horas sin comer'],
    'cetogenica': ['cetogénica', 'keto', 'ceto', 'baja en carbohidratos'],
    'dash': ['dash', 'baja en sodio', 'hipertensión', 'baja en sal'],
    'flexitariana': ['flexitariana', 'vegetariana flexible', 'ocasionalmente carne'],
    'low_carb': ['low carb', 'baja en carbohidratos', 'pocos hidratos'],
    'mediterranea': ['mediterránea', 'aceite de oliva', 'frutas', 'legumbres', 'pescado'],
    'paleo': ['paleo', 'carne', 'carnivora', 'proteína', 'caza', 'pescado'],
    'raw_food': ['crudivegana', 'raw food', 'comida cruda', 'raw'],
    'sin_azucar': ['sin azúcar', 'sin azúcares añadidos', 'sugar free'],
    'sin_gluten': ['sin gluten', 'gluten free', 'celíaco'],
    'sin_lacteos': ['sin lacteos', 'sin lácteos', 'lactosa', 'lactosa free'],
    'vegetariana': ['vegetariana', 'vegetales', 'plantas', 'verduras'],
    'vegana': ['vegana', 'vegano', 'sin productos animales', 'solo vegetal']
}

diet_keywords = {
    'alta_proteina': ['Beef', 'Chicken', 'Seafood'],
    'cetogenica': ['Beef', 'Pork', 'Lamb'], # Dietas altas en grasa animal
    'mediterranea': ['Seafood', 'Vegetarian'], # Pescado y muchos vegetales
    'vegetariana': ['Vegetarian'],
    'vegana': ['Vegan'],
    'sin_gluten': ['Vegetarian', 'Pasta', 'Breakfast', 'Dessert', 'Side', 'Starter', 'Miscellaneous'], # Depende del plato
    'sin_lacteos': ['Vegetarian', 'Beef', 'Chicken', 'Seafood', 'Pasta', 'Breakfast', 'Dessert', 'Side', 'Starter', 'Miscellaneous', 'Vegan'], # Depende del plato
    'ayuno_intermitente': ['Miscellaneous'],
    'dash': ['Vegetarian', 'Seafood', 'Chicken'], # Bajo en sodio, enfocado en frutas, verduras, pescado, pollo sin piel
    'flexitariana': ['Beef', 'Chicken', 'Seafood', 'Vegetarian'], # Amplia variedad
    'low_carb': ['Beef', 'Chicken', 'Seafood', 'Pork', 'Lamb'],
    'paleo': ['Beef', 'Chicken', 'Seafood', 'Lamb', 'Goat'], # Carnes magras, pescado, excluye granos y lácteos
    'raw_food': ['Vegan'],
    'sin_azucar': ['Dessert', 'Breakfast', 'Miscellaneous'], # Postres, desayunos y otros sin azúcar
}

# Palabras clave para objetivos fitness
objective_keywords = {
    'perder_peso': ['perder', 'adelgazar', 'bajar'],
    'ganar_musculo': ['músculo', 'fuerza', 'ganar músculo', 'entrenar fuerza', 'musculación'],
    'mantener_peso': ['mantener', 'mantener peso', 'mantenerme en forma', 'mantener mi peso']
}

# Modelo de entrada para la API
class InputText(BaseModel):
    texto: str

# Función para analizar texto y detectar dieta + objetivo
def analizar_texto(texto):
    doc = nlp(texto.lower())
    words_filtered = [token.text for token in doc if not token.is_stop]
    print(words_filtered)
    # Buscar categorías de dieta directamente
    diet = None
    for key, keywords in diet_keywords_es.items():
        if any(keyword in words_filtered for keyword in keywords):
            diet = key

    # Buscar objetivo (asumiendo que objective_keywords sigue la misma estructura anterior)
    objective = None
    for key, keywords in objective_keywords.items():
        if any(keyword in words_filtered for keyword in keywords):
            objective = key
            break

    if not objective:
        objective = 'perder_peso'

    return {'dieta': diet, 'objetivo': objective}

# Función para buscar recetas desde TheMealDB API
def buscar_recetas(dieta_detectada):
    if dieta_detectada is None:
        return {"error": "No se detectó ninguna dieta"}
    recetas = {"meals": []}
    categorias_buscadas = set() # Para evitar buscar la misma categoría múltiples veces
    translator = GoogleTranslator(source='en', target='es')

    for categoria in dieta_detectada:
        categoria_lower = categoria.lower() # Asegurarse de que la búsqueda sea insensible a mayúsculas
        if categoria_lower not in categorias_buscadas:
            categorias_buscadas.add(categoria_lower)
            url = f"https://www.themealdb.com/api/json/v1/1/filter.php?c={categoria_lower}"
            response = requests.get(url)

            if response.status_code == 200 and response.json().get('meals'):
               data = response.json()
               for receta_basica in data['meals']:
                   url = f"https://www.themealdb.com/api/json/v1/1/lookup.php?i={receta_basica['idMeal']}"
                   item_response = requests.get(url)
                   if item_response.status_code == 200:
                       item_data = item_response.json()
                       if 'meals' in item_data and item_data['meals']:
                           meal_data = item_data['meals'][0]
                           print("MEALM DATA")
                           recetas["meals"].append(meal_data) #sin traducir

                       """translated_item = {}

                       for key, value in meal_data.items():
                       # No traducimos URLs ni IDs, lo demás sí
                           #if isinstance(value, str) and not value.startswith("http") and not key.startswith("id"):
                           translated_item[key] = translate_text(value)
                           #else:
                              # translated_item[key] = value

                       ingredients = []
                       for i in range(1, 21):
                           ingredient = meal_data.get(f'strIngredient{i}')
                           measure = meal_data.get(f'strMeasure{i}')
                           if ingredient and ingredient.strip():
                               ingredients.append({
                                   "ingredient": translate_text(ingredient),
                                   "measure": translate_text(measure) if measure else ''
                               })

                       translated_item['ingredients'] = ingredients
                       recetas["meals"].append(translated_item)"""

        else:
            print("error with url")
            print(url)
            #conda activate healthygoals_v2
            #python -m uvicorn main:app --reload --host 0.0.0.0

    return recetas
    if response.status_code == 200:
        return recetas
    else:
        return {"error": "No se pudieron obtener recetas", "status": response.status_code}

def translate_text(text, target_lang="es"):
    if not text:
        return ""
    translator = Translator(to_lang=target_lang)
    translation = translator.translate(text)
    return translation

def generar_plan_semanal(recetas):
    dias_semana = ["lunes", "martes", "miercoles", "jueves", "viernes", "sabado", "domingo"]
    comidas = ["desayuno", "comida", "merienda", "cena"]
    plan_semanal = {}

    if not recetas:
        return {"mensaje": "No se encontraron recetas para esta dieta"}

    for dia in dias_semana:
        plan_semanal[dia] = {}
        recetas_del_dia = random.sample(recetas["meals"], min(len(recetas["meals"]), len(comidas)))
        for i, comida in enumerate(comidas):
            # Si hay menos recetas que comidas, repetirá cuando toque (aunque puedes manejarlo)
            if i < len(recetas_del_dia):
                receta_seleccionada = recetas_del_dia[i]
            else:
                receta_seleccionada = random.choice(recetas["meals"])

            plan_semanal[dia][comida] = receta_seleccionada
    return plan_semanal

def getRecipe(url):
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        return data
@app.head("/")
async def detection():
    return True
# Endpoint para recibir texto, analizarlo y sugerir recetas
@app.post("/analizar-texto/")
async def analizar_texto_endpoint(input: InputText):
    print("llega")
    print(input)
    resultado = analizar_texto(input.texto)
    print(resultado)
    if not resultado['dieta']:
        raise HTTPException(status_code=400, detail="No se detectó ninguna dieta en el texto proporcionado.")

    if not resultado['objetivo']:
        raise HTTPException(status_code=400, detail="No se detectó ningún objetivo fitness en el texto proporcionado.")

    categories_to_search = []
    for dieta in resultado['dieta']:
        categories_to_search.extend(diet_keywords.get(dieta, []))
    categories_to_search = list(set(categories_to_search))

    diet_categories = []
    for key, keywords in diet_keywords.items():
        if key == resultado['dieta']:
            print(key)
            print(keywords)
            diet_categories = keywords


    print(categories_to_search)
    # Buscar recetas si se detectó alguna dieta
    recetas = buscar_recetas(diet_categories) if diet_categories else {"mensaje": "No se detectó dieta"}
    if not recetas or not recetas.get('meals'):
        raise HTTPException(status_code=404, detail="No se encontraron recetas para la dieta detectada.")

    # Generar plan semanal si se detectó alguna dieta
    plan_semanal = generar_plan_semanal(recetas) if recetas else {"mensaje": "No se detectó dieta"}
    if not plan_semanal or "mensaje" in plan_semanal:
        raise HTTPException(status_code=404, detail="No se pudo generar un plan semanal con las recetas disponibles.")

    return {
        "analisis": resultado,
        "recipes": recetas,
        "semanal_planning": plan_semanal
    }