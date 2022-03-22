import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vegan_recipes/Screens/RecipeDetails.dart';
import 'package:vegan_recipes/Model/RecipeMode.dart';
import 'package:vegan_recipes/Model/RecipeAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewRecipe extends StatefulWidget {
  @override
  State<NewRecipe> createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  late List<RecipeModel> _recipes;

  bool _isLoading = true;
  ScrollController scrollController = ScrollController();
  bool showbtn = false;

  @override
  void initState() {
    scrollController.addListener(() { //scroll listener
      double showoffset = 2000.0; //Back to top botton will show on scroll offset 10.0

      if(scrollController.offset > showoffset){
        showbtn = true;
        setState(() {
          //update state
        });
      }else{
        showbtn = false;
        setState(() {
          //update state
        });
      }
    });
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    _recipes = await recipeAPI.getRecipe();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: AnimatedOpacity(
          duration: Duration(milliseconds: 1000),
          opacity: showbtn?1.0:0.0,
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              scrollController.animateTo(
                  0,
                  duration: Duration(milliseconds: 500),
                  curve:Curves.fastOutSlowIn
              );
            },
            child: Icon(Icons.arrow_upward,color: Colors.black,),
            backgroundColor: Colors.white,
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: getRecipes,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _recipes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetails(
                                      recipeModel: _recipes[index],
                                    ),
                                  )),
                              child: RecipeCard(
                                recipeModel: _recipes[index],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              )
    );
  }
}

class RecipeCard extends StatefulWidget {
  final RecipeModel recipeModel;
  RecipeCard({
    required this.recipeModel,
  });

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Hero(
                  tag: widget.recipeModel.images,
                  child: Image(
                    height: 320,
                    width: 320,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.recipeModel.images),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 40,
              child: InkWell(
                onTap: () {
                  setState(() {
                    saved = !saved;
                    widget.recipeModel.like = !widget.recipeModel.like;

                    if (widget.recipeModel.like) {
                      createFav(recipe: widget.recipeModel);
                    }
                  });
                },
                child: Icon(
                  widget.recipeModel.like
                      ? FlutterIcons.bookmark_check_mco
                      : FlutterIcons.bookmark_outline_mco,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipeModel.name,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),

                  ],
                ),
              ),
              // Spacer(),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 3,
                    ),
                    Icon(
                      FlutterIcons.timer_mco,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      ((widget.recipeModel.totalTime) ~/ 60).toString() + '\'',
                    ),
                    Spacer(),
                    Icon(
                      FlutterIcons.star_face_mco,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      ((widget.recipeModel.rating).toStringAsFixed(1)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future createFav({required RecipeModel recipe}) async {
  final docFav = FirebaseFirestore.instance.collection('favs').doc();

  final fav = Fav(
    id: docFav.id,
    name: recipe.name,
    url: recipe.url,
    totalTime: recipe.totalTime,
    servings: recipe.servings,
    images: recipe.images,
    ingredients: recipe.ingredients,
    preparations: recipe.preparations,
    rating: recipe.rating,
    loved: recipe.loved,
    like: recipe.like,
  );

  final json = fav.toJson();

  await docFav.set(json);
}

class Fav {
  final String id, name, url, images;
  final int totalTime, servings, loved;
  final List<dynamic> ingredients;
  final List<dynamic> preparations;
  final double rating;
  late final bool like;
  Fav({
    this.id = '',
    required this.name,
    required this.url,
    required this.totalTime,
    required this.servings,
    required this.images,
    required this.ingredients,
    required this.preparations,
    required this.rating,
    required this.loved,
    required this.like,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'totalTime': totalTime,
        'servings': servings,
        'images': images,
        'ingredients': ingredients,
        'preparations': preparations,
        'rating': rating,
        'loved': loved,
        'like': like,
      };

  static Fav fromJson(Map<String, dynamic> json) => Fav(
        id: json['id'],
        name: json['name'],
        url: json['url'],
        totalTime: json['totalTime'],
        servings: json['servings'],
        images: json['images'],
        ingredients: json['ingredients'],
        preparations: json['preparations'],
        rating: json['rating'],
        loved: json['loved'],
        like: json['like'],
      );
}
