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

#load environment variables from .env file
load_dotenv()

#load spacy model for spanish
nlp = spacy.load("es_core_news_sm")

#initialize fastapi app
app = FastAPI()

#set cors configuration to allow requests from any frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

#spanish diet-related keywords mapped to internal identifiers
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

#mapping of internal diet identifiers to mealdb api categories
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

#keywords related to fitness goals
objective_keywords = {
    'perder_peso': ['perder', 'adelgazar', 'bajar'],
    'ganar_musculo': ['músculo', 'fuerza', 'ganar músculo', 'entrenar fuerza', 'musculación'],
    'mantener_peso': ['mantener', 'mantener peso', 'mantenerme en forma', 'mantener mi peso']
}

#input model for the api
class InputText(BaseModel):
    text: str

#function to analyze user input and detect diet and fitness goal
def analyze_text(text):
    doc = nlp(text.lower())
    words_filtered = [token.text for token in doc if not token.is_stop]
    print(words_filtered)

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

#function to fetch recipes from themealdb based on diet categories
def search_recipes(diet_detected):
    if diet_detected is None:
        return {"error": "no se detectó ninguna dieta"}

    meals = {"meals": []}
    searched_categories = set()
    translator = GoogleTranslator(source='en', target='es')

    for category in diet_detected:
        lower_category = category.lower()
        if lower_category not in searched_categories:
            searched_categories.add(lower_category)
            url = f"https://www.themealdb.com/api/json/v1/1/filter.php?c={lower_category}"
            response = requests.get(url)

            if response.status_code == 200 and response.json().get('meals'):
                data = response.json()
                for basic_recipe in data['meals']:
                    url = f"https://www.themealdb.com/api/json/v1/1/lookup.php?i={basic_recipe['idMeal']}"
                    item_response = requests.get(url)
                    if item_response.status_code == 200:
                        item_data = item_response.json()
                        if 'meals' in item_data and item_data['meals']:
                            meal_data = item_data['meals'][0]
                            meals["meals"].append(meal_data)

        else:
            print("error with url")
            print(url)

    return meals

#function to translate text using translate module
def translate_text(text, target_lang="es"):
    if not text:
        return ""
    translator = Translator(to_lang=target_lang)
    translation = translator.translate(text)
    return translation

#function to generate a weekly plan from recipe data
def generarate_weekly_plan(recipes):
    week_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    meals = ["breakfast", "lunch", "snack", "dinner"]
    weekly_plan = {}

    if not recipes:
        return {"mensaje": "no se encontraron recetas para esta dieta"}

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

#function to fetch a single recipe from a given url
def getRecipe(url):
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        return data

#fastapi head endpoint to test if service is alive
@app.head("/")
async def detection():
    return True

#post endpoint to analyze input text and return analysis, recipes, and weekly plan
@app.post("/analizar-texto/")
async def analyze_text_endpoint(input: InputText):
    print("llega")
    print(input)
    result = analyze_text(input.text)
    print(result)

    if not result['diet']:
        raise HTTPException(status_code=400, detail="no se detectó ninguna dieta en el texto proporcionado.")

    if not result['objetive']:
        raise HTTPException(status_code=400, detail="no se detectó ningún objetivo fitness en el texto proporcionado.")

    categories_to_search = []
    for diet in result['diet']:
        categories_to_search.extend(diet_keywords.get(diet, []))
    categories_to_search = list(set(categories_to_search))

    diet_categories = []
    for key, keywords in diet_keywords.items():
        if key == result['diet']:
            print(key)
            print(keywords)
            diet_categories = keywords

    print(categories_to_search)

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
