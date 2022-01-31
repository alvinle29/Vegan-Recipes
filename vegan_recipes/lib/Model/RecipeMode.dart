import 'package:flutter/material.dart';

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


  /*static List<RecipeModel> demoRecipe = [
    RecipeModel(
      title: 'Gruyère, Bacon, and Spinach Scrambled Eggs',
      writer: "",
      description:
      'A touch of Dijon mustard, salty bacon, melty cheese, and a handful of greens seriously upgrades scrambled eggs, without too much effort!',
      totalTime: 10,
      servings: 4,
      imgPath: 'images/img1.jpg',
      ingredients: [
        '8 large eggs',
        '1 tsp. Dijon mustard',
        'Kosher salt and pepper',
        '1 tbsp. olive oil or unsalted butter',
        '2 slices thick-cut bacon, cooked and broken into pieces',
        '2 c. spinach, torn',
        '2 oz. Gruyère cheese, shredded',
      ],
    ),
    RecipeModel(
      title: 'Classic Omelet and Greens ',
      writer: "",
      description:
      'Sneak some spinach into your morning meal for a boost of nutrients to start your day off right.',
      totalTime: 10,
      servings: 4,
      imgPath: 'images/img2.jpg',
      ingredients: [
        '8 large eggs',
        '1 tsp. Dijon mustard',
        'Kosher salt and pepper',
        '1 tbsp. olive oil or unsalted butter',
        '2 slices thick-cut bacon, cooked and broken into pieces',
        '2 c. spinach, torn',
        '2 oz. Gruyère cheese, shredded',
      ],
    ),
    RecipeModel(
      title: 'Sheet Pan Sausage and Egg Breakfast Bake ',
      writer: "",
      description:
      'A hearty breakfast that easily feeds a family of four, all on one sheet pan? Yes, please.',
      totalTime: 10,
      servings: 4,
      imgPath: 'images/img3.jpg',
      ingredients: [
        '8 large eggs',
        '1 tsp. Dijon mustard',
        'Kosher salt and pepper',
        '1 tbsp. olive oil or unsalted butter',
        '2 slices thick-cut bacon, cooked and broken into pieces',
        '2 c. spinach, torn',
        '2 oz. Gruyère cheese, shredded',
      ],
    ),
    RecipeModel(
      title: 'Shakshuka',
      writer: "",
      description:
      'Just wait til you break this one out at the breakfast table: sweet tomatoes, runny yolks, and plenty of toasted bread for dipping.',
      totalTime: 10,
      servings: 4,
      imgPath: 'images/img4.jpg',
      ingredients: [
        '8 large eggs',
        '1 tsp. Dijon mustard',
        'Kosher salt and pepper',
        '1 tbsp. olive oil or unsalted butter',
        '2 slices thick-cut bacon, cooked and broken into pieces',
        '2 c. spinach, torn',
        '2 oz. Gruyère cheese, shredded',
      ],
    ),
  ];*/

}