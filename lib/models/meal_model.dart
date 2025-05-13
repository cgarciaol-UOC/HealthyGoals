class Meal {
  final String? idMeal; // ID único de la receta
  final String? strInstructions; // Instrucciones de preparación
  final String?
  strCategory; // Categoría de la receta (por ejemplo, desayuno, almuerzo)
  final String strMeal; // Nombre de la receta
  final String strMealThumb; // URL de la imagen de la receta
  final String title; // Título que se pasa al construir la receta
  final Map<String, int>
  ingredients; // Mapa de ingredientes (nombre del ingrediente -> cantidad)
  final Map<String, dynamic>
  mealData; // Datos completos de la receta en formato JSON

  // Constructor de la clase Meal
  Meal({
    this.idMeal,
    this.strInstructions,
    this.strCategory,
    required this.strMeal,
    required this.strMealThumb,
    required this.title,
    required this.ingredients,
    required this.mealData,
  });

  // Función de fábrica para crear un objeto Meal a partir de un JSON
  factory Meal.fromJson(Map<String, dynamic> json, String title) {
    final Map<String, int> ingredientsMap =
        {}; // Mapa para almacenar ingredientes y sus cantidades

    // Iteramos sobre los ingredientes, que están numerados del 1 al 20
    for (var i = 1; i <= 20; i++) {
      final ingredient =
          json['strIngredient$i']; // Obtenemos el ingrediente en la posición i

      // Verificamos que el ingrediente no sea nulo ni vacío
      if (ingredient != null && ingredient.isNotEmpty) {
        final ingredientName =
            ingredient
                .toString()
                .toLowerCase()
                .replaceAll(
                  RegExp(
                    r'\d+|\s+|\(|\)|\-',
                  ), // Normalizamos el nombre del ingrediente
                  '', // Eliminamos números, espacios, paréntesis y guiones
                )
                .trim();

        // Si el nombre del ingrediente no está vacío
        if (ingredientName.isNotEmpty) {
          // Verificamos si el ingrediente ya existe en el mapa
          if (ingredientsMap.containsKey(ingredientName)) {
            // Si ya existe, sumamos 1 a la cantidad
            ingredientsMap[ingredientName] =
                ingredientsMap[ingredientName]! + 1;
          } else {
            // Si no existe, lo agregamos con valor 1
            ingredientsMap[ingredientName] = 1;
          }
        }
      }
    }

    // Retornamos el objeto Meal con todos los datos del JSON y el título
    return Meal(
      idMeal: json['idMeal'], // ID de la receta
      strMeal: json['strMeal'], // Nombre de la receta
      title: title, // Título proporcionado
      strInstructions: json['strInstructions'], // Instrucciones de preparación
      strCategory: json['strCategory'], // Categoría de la receta
      strMealThumb: json['strMealThumb'], // URL de la imagen
      ingredients: ingredientsMap, // Mapa de ingredientes y sus cantidades
      mealData: json, // Datos completos de la receta
    );
  }
}
