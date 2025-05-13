from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import spacy
import requests
import os
import random
from dotenv import load_dotenv
#from deep_translator import GoogleTranslator
#from translate import Translator

#cargar variables de entorno desde archivo .env
load_dotenv()

#carga el modelo de lenguaje español de spaCy
nlp = spacy.load("es_core_news_sm")

#inicia la aplicación FastAPI
app = FastAPI()

#establece el middleware CORS para permitir solicitudes desde cualquier origen
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

#este es el diccionario de palabras clave para identificar diferentes tipos de dietas en español
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

#este es el diccionario de palabras clave para identificar diferentes categorías de comidas en inglés
diet_keywords = {
    'alta_proteina': ['Beef', 'Chicken', 'Seafood'],
    'cetogenica': ['Beef', 'Pork', 'Lamb'],
    'mediterranea': ['Seafood', 'Vegetarian'],
    'vegetariana': ['Vegetarian'],
    'vegana': ['Vegan'],
    'sin_gluten': ['Vegetarian', 'Pasta', 'Breakfast', 'Dessert', 'Side', 'Starter', 'Miscellaneous'],
    'sin_lacteos': ['Vegetarian', 'Beef', 'Chicken', 'Seafood', 'Pasta', 'Breakfast', 'Dessert', 'Side', 'Starter', 'Miscellaneous', 'Vegan'],
    'ayuno_intermitente': ['Miscellaneous'],
    'dash': ['Vegetarian', 'Seafood', 'Chicken'],
    'flexitariana': ['Beef', 'Chicken', 'Seafood', 'Vegetarian'],
    'low_carb': ['Beef', 'Chicken', 'Seafood', 'Pork', 'Lamb'],
    'paleo': ['Beef', 'Chicken', 'Seafood', 'Lamb', 'Goat'],
    'raw_food': ['Vegan'],
    'sin_azucar': ['Dessert', 'Breakfast', 'Miscellaneous'],
}

#estas son las palabras clave para identificar diferentes objetivos fitness en español
objective_keywords = {
    'perder_peso': ['perder', 'adelgazar', 'bajar'],
    'ganar_musculo': ['músculo', 'fuerza', 'ganar músculo', 'entrenar fuerza', 'musculación'],
    'mantener_peso': ['mantener', 'mantener peso', 'mantenerme en forma', 'mantener mi peso']
}

#este es el modelo de datos para recibir texto de entrada
class InputText(BaseModel):
    text: str

#funcion para analizar el texto y detectar dieta y objetivo fitness
def analyze_text(text):
    doc = nlp(text.lower())
    words_filtered = [token.text for token in doc if not token.is_stop]

    diet = None
    for key, keywords in diet_keywords_es.items():
        if any(keyword in words_filtered for keyword in keywords):
            diet = key

    objective = None
    for key, keywords in objective_keywords.items():
        if any(keyword in words_filtered for keyword in keywords):
            objective = key
            break

    if not objective:
        objective = 'perder_peso'

    return {'diet': diet, 'objetive': objective}

#funcion para buscar recetas basadas en la dieta detectada
def search_recipes(diet_detected):
    if diet_detected is None:
        return {"error": "no se detectó ninguna dieta"}

    meals = {"meals": []}
    searched_categories = set()
    #translator = GoogleTranslator(source='en', target='es')
    # busca recetas para cada categoría de dieta detectada
    for category in diet_detected:
        lower_category = category.lower()
        if lower_category not in searched_categories:
            searched_categories.add(lower_category)
            url = f"https://www.themealdb.com/api/json/v1/1/filter.php?c={lower_category}"
            response = requests.get(url)
            #si encuentra recetas, las agrega a la lista de comidas
            if response.status_code == 200 and response.json().get('meals'):
                data = response.json()
                for basic_recipe in data['meals']:
                    url = f"https://www.themealdb.com/api/json/v1/1/lookup.php?i={basic_recipe['idMeal']}"
                    item_response = requests.get(url)
                    if item_response.status_code == 200:
                        item_data = item_response.json()
                        if 'meals' in item_data and item_data['meals']:
                            meal_data = item_data['meals'][0]
                            # aqui se llamaria a la funcion translate_text para traducir los elementos de la receta
                            meals["meals"].append(meal_data)

        else:
            print("error with url")
            print(url)

    return meals

#funcion para traducir texto a español
def translate_text(text, target_lang="es"):
    if not text:
        return ""
    translator = Translator(to_lang=target_lang)
    translation = translator.translate(text)
    return translation

#función para generar un plan semanal basado en las recetas encontradas
def generarate_weekly_plan(recipes):
    week_days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    meals = ["breakfast", "lunch", "snack", "dinner"]
    weekly_plan = {}

    if not recipes:
        return {"mensaje": "no se encontraron recetas para esta dieta"}
    # genera un plan semanal asignando recetas aleatorias a cada día y comida
    for day in week_days:
        weekly_plan[day] = {}
        recipes_of_the_day = random.sample(recipes["meals"], min(len(recipes["meals"]), len(meals)))
        for i, meal in enumerate(meals):
            if i < len(recipes_of_the_day):
                selected_recipe = recipes_of_the_day[i]
            else:
                selected_recipe = random.choice(recipes["meals"])

            weekly_plan[day][meal] = selected_recipe
    return weekly_plan

# funcion para obtener una receta específica por su ID
def getRecipe(url):
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        return data

# endpoint para detectar si el servidor está funcionando
@app.head("/")
async def detection():
    return True

# endpoint para analizar texto y generar un plan semanal
@app.post("/analizar-texto/")
async def analyze_text_endpoint(input: InputText):
    result = analyze_text(input.text)
    if not result['diet']:
        raise HTTPException(status_code=400, detail="no se detectó ninguna dieta en el texto proporcionado.")

    if not result['objetive']:
        raise HTTPException(status_code=400, detail="no se detectó ningún objetivo fitness en el texto proporcionado.")

    # obtiene las categorías de recetas correspondientes a la dieta detectada
    categories_to_search = []
    for diet in result['diet']:
        categories_to_search.extend(diet_keywords.get(diet, []))
    categories_to_search = list(set(categories_to_search))
    # busca recetas basadas en las categorías detectadas
    diet_categories = []
    for key, keywords in diet_keywords.items():
        if key == result['diet']:
            diet_categories = keywords

    recipes = search_recipes(diet_categories) if diet_categories else {"mensaje": "no se detectó dieta"}
    if not recipes or not recipes.get('meals'):
        raise HTTPException(status_code=404, detail="no se encontraron recetas para la dieta detectada.")

    weekly_plan = generarate_weekly_plan(recipes) if recipes else {"mensaje": "no se detectó dieta"}
    if not weekly_plan or "mensaje" in weekly_plan:
        raise HTTPException(status_code=404, detail="no se pudo generar un plan semanal con las recetas disponibles.")

    return {
        "analysis": result,
        "recipes": recipes,
        "semanal_planning": weekly_plan
    }
