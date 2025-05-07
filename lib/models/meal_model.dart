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

  // Función única para crear el Meal desde JSON y combinar ingredientes duplicados
  factory Meal.fromJson(Map<String, dynamic> json, String title) {
    final Map<String, int> ingredientsMap =
        {}; // Mapa para almacenar los ingredientes

    for (var i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];

      // Verificamos que el ingrediente no sea nulo ni vacío
      if (ingredient != null && ingredient.isNotEmpty) {
        final ingredientName =
            ingredient
                .toString()
                .toLowerCase()
                .replaceAll(
                  RegExp(r'\d+|\s+|\(|\)|\-'),
                  '', // Normaliza el nombre del ingrediente
                )
                .trim();

        // Si el nombre del ingrediente no está vacío
        if (ingredientName.isNotEmpty) {
          // Verificamos si el ingrediente ya existe en el mapa
          if (ingredientsMap.containsKey(ingredientName)) {
            // Si existe, sumamos 1
            ingredientsMap[ingredientName] =
                ingredientsMap[ingredientName]! + 1;
          } else {
            // Si no existe, lo agregamos con valor 1
            ingredientsMap[ingredientName] = 1;
          }
        }
      }
    }

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
