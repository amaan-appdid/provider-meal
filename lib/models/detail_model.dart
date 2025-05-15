class DetailModel {
  final String strMeal;
  final String strMealThumb;
  final String strInstructions;
  final List<Map<String, String>> ingredients;

  DetailModel({
    required this.strMeal,
    required this.strMealThumb,
    required this.strInstructions,
    required this.ingredients,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> ingredientsList = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty && measure != null && measure.toString().trim().isNotEmpty) {
        ingredientsList.add({ingredient: measure});
      }
    }

    return DetailModel(
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strInstructions: json['strInstructions'] ?? '',
      ingredients: ingredientsList,
    );
  }
}




                              // ...item.ingredients.map(
                              //   (entry) {
                              //     final ingredient = entry.keys.first;
                              //     final measure = entry.values.first;
                              //     return TableRow(
                              //       children: [
                              //         Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Text(ingredient),
                              //         ),
                              //         Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Text(measure),
                              //         ),
                              //       ],
                              //     );
                              //   },
                              // ).toList(),
