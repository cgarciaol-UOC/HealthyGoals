class Meal {
  final String? idMeal;
  final String? strInstructions;
  final String? strCategory;
  final String strMeal;
  final String strMealThumb;
  final String title;
  final Map<String, int> ingredients;
  final Map<String, dynamic> mealData;

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

  // esta función crea un objeto Meal a partir de un JSON
  factory Meal.fromJson(Map<String, dynamic> json, String title) {
    final Map<String, int> ingredientsMap = {};
    // se itera sobre los ingredientes del JSON
    for (var i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        // normalizamos el nombre del ingrediente eliminando números, espacios...
        final ingredientName =
            ingredient
                .toString()
                .toLowerCase()
                .replaceAll(RegExp(r'\d+|\s+|\(|\)|\-'), '')
                .trim();
        if (ingredientName.isNotEmpty) {
          // verificamos si el ingrediente ya existe en el mapa
          if (ingredientsMap.containsKey(ingredientName)) {
            // sii ya existe, sumamos 1 a la cantidad
            ingredientsMap[ingredientName] =
                ingredientsMap[ingredientName]! + 1;
          } else {
            // sino, le añadimos 1
            ingredientsMap[ingredientName] = 1;
          }
        }
      }
    }
    // devolvemos un objeto Meal con los datos extraídos del JSON
    return Meal(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      title: title,
      strInstructions: json['strInstructions'],
      strCategory: json['strCategory'],
      strMealThumb: json['strMealThumb'],
      ingredients: ingredientsMap,
      mealData: json,
    );
  }
}
