class RecipeModel {
  String name, url;
  //String description;
  int totalTime;
  int servings;
  int loved;
  double rating;
  List<String> ingredients = [];
  List<String> preparations = [];
  String images;
  bool like = false;
  RecipeModel({
    required this.name,
    required this.url,
    //required this.description,
    required this.totalTime,
    required this.servings,
    required this.images,
    required this.ingredients,
    required this.preparations,
    required this.rating,
    required this.loved,
  });

  static List<RecipeModel> demoRecipe = [];

  factory RecipeModel.fromJson(dynamic json) {

    List<String> preparation =[];
    List<String> ingredient =[];

    for (int i=0; i< json['content']['ingredientLines'].length;i++){
      if (json['content']['ingredientLines'][i]['wholeLine'] != ''){
        ingredient.add(json['content']['ingredientLines'][i]['wholeLine'] as String);
      }
    };
    if (json['content']['preparationSteps'] != null) {
      for (int i = 0; i < json['content']['preparationSteps'].length; i++) {
        preparation.add(json['content']['preparationSteps'][i] as String);
      }
    };

    return RecipeModel(
        name: json['content']['details']['name'] as String,
        url: json['display']['source']['sourceRecipeUrl'] as String,
        images: json['content']['details']['images'][0]['hostedLargeUrl'] as String,
        rating: json['content']['reviews']['averageRating'] as double,
        servings: json['content']['details']['numberOfServings'] as int,
        loved: json['content']['yums']['count'] as int,
        //description: json['description']['text'] as String,
        ingredients: ingredient as List<String>,
        preparations: preparation as List<String>,
        totalTime: json['content']['details']['totalTimeInSeconds'] as int,
    );
  }

  static List<RecipeModel> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data){
      return RecipeModel.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return 'Recipe {name: $name, image: $images, rating: $rating, totalTime: $totalTime}';
  }
}