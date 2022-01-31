import 'dart:convert';
import 'dart:math';
import 'package:vegan_recipes/Model/RecipeMode.dart';
import 'package:http/http.dart' as http;

class recipeAPI {
  static Future<List<RecipeModel>> getRecipe() async{

    var rand = Random();
    String k = rand.nextInt(200).toString();
    print(k);
    var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/list',
        {"limit": "25", "start": k, "tag": "list.recipe.search_based:fq:diet_inclusion_s_mv:386\^Vegan"});

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "4c89c81169mshe9e776e8437368bp159829jsn1e30c92e44de",
      "x-rapidapi-host": "yummly2.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body);
    List _temp = [];

    for (var i in data['feed']) {
      _temp.add(i);
    }

    return RecipeModel.recipesFromSnapshot(_temp);
  }
}