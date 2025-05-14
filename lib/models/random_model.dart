class RandomModel {
  final String name;
  final String imageUrl;
  final String instructions;

  RandomModel({
    required this.name,
    required this.imageUrl,
    required this.instructions,
  });

  factory RandomModel.fromJson(Map<String, dynamic> json) {
    return RandomModel(
      name: json['strMeal'],
      imageUrl: json['strMealThumb'],
      instructions: json['strInstructions'],
    );
  }
}
