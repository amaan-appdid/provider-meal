class DetailModel {
  final String strMeal;
  final String strMealThumb;
  final String strInstructions;
  final String strYoutube;
  final List<Map<String, String>> ingredients;

  DetailModel({
    required this.strMeal,
    required this.strMealThumb,
    required this.strInstructions,
    required this.strYoutube,
    required this.ingredients,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> ingredientsList = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty && measure != null && measure.toString().trim().isNotEmpty) {
        ingredientsList.add({ingredient.toString(): measure.toString()});
      }
    }

    return DetailModel(
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strInstructions: json['strInstructions'] ?? '',
      strYoutube: json['strYoutube'] ?? '',
      ingredients: ingredientsList,
    );
  }
}
