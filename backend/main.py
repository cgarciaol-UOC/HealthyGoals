from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import spacy

# Cargar el modelo de spaCy para español
nlp = spacy.load("es_core_news_sm")

# Inicializar FastAPI
app = FastAPI()

# Configuración de CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permite solicitudes desde cualquier origen
    allow_credentials=True,
    allow_methods=["*"],  # Permite todos los métodos HTTP (GET, POST, etc.)
    allow_headers=["*"],  # Permite todos los encabezados
)

# Palabras clave para dietas y objetivos
diet_keywords = {
    'vegetariana': ['vegetariana', 'vegana', 'vegetales', 'plantas'],
    'paleo': ['paleo', 'carnes', 'proteína'],
    'sin_gluten': ['sin gluten', 'gluten free'],
    'sin_lacteos': ['sin lácteos', 'lactosa', 'lactosa free'],
}

objective_keywords = {
    'perder_peso': ['perder peso', 'adelgazar', 'bajar de peso'],
    'ganar_musculo': ['ganar músculo', 'entrenar fuerza', 'musculación'],
    'mantener_peso': ['mantener peso', 'mantenerme en forma', 'mantener mi peso']
}

# Modelo de entrada para la API
class InputText(BaseModel):
    texto: str

# Función para analizar el texto
def analizar_texto(texto):
    doc = nlp(texto.lower())
    words_filtered = [token.text for token in doc if not token.is_stop]
    
    diet = None
    for key, keywords in diet_keywords.items():
        if any(keyword in words_filtered for keyword in keywords):
            diet = key
    
    objective = None
    for key, keywords in objective_keywords.items():
        if any(keyword in words_filtered for keyword in keywords):
            objective = key
    
    return {'dieta': diet, 'objetivo': objective}

@app.post("/analizar-texto/")
async def analizar_texto_endpoint(input: InputText):
    resultado = analizar_texto(input.texto)
    return resultado