import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/link.dart';
import 'package:vegan_recipes/Model/RecipeMode.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:vegan_recipes/NewRecipe.dart';

class RecipeDetails extends StatefulWidget {
  final RecipeModel recipeModel;
  RecipeDetails({
    required this.recipeModel,
  });

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _textTheme = Theme.of(context).textTheme;

    if (widget.recipeModel.ingredients == null) {
    }
    return Scaffold(
      body: SlidingUpPanel(
        parallaxEnabled: true,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        minHeight: (size.height / 2),
        maxHeight: size.height / 1.2,
        panel: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                widget.recipeModel.name,
                style: _textTheme.headline6,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    FlutterIcons.heart_circle_mco,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.recipeModel.loved.toString()[0] + 'k',
                    // style: _textTheme.caption,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    FlutterIcons.timer_mco,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    (widget.recipeModel.totalTime ~/ 60).toString() + '\'',
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.recipeModel.servings.toString() + ' Servings',
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.black.withOpacity(0.3),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.black,
                        indicator: DotIndicator(
                          color: Colors.black,
                          distanceFromCenter: 16,
                          radius: 3,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        unselectedLabelColor: Colors.black.withOpacity(0.3),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        labelPadding: EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                        tabs: [
                          Tab(
                            text: "Ingredients".toUpperCase(),
                          ),
                          Tab(
                            text: "Preparation".toUpperCase(),
                          ),
                          Tab(
                            text: "Link".toUpperCase(),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      Expanded(
                          child: TabBarView(children: [
                        Ingredients(recipeModel: widget.recipeModel),
                        Preparations(recipeModel: widget.recipeModel),
                            Links(recipeModel: widget.recipeModel),
                      ]))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: widget.recipeModel.images,
                    child: ClipRRect(
                      child: Image(
                        width: double.infinity,
                        height: (size.height / 2) + 50,
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.recipeModel.images),
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                top: 40,
                right: 20,
                child: InkWell(
                  onTap: () {
                    setState(() {
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
              Positioned(
                top: 40,
                left: 20,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Ingredients extends StatelessWidget {
  const Ingredients({
    Key? key,
    required this.recipeModel,
  }) : super(key: key);

  final RecipeModel recipeModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: recipeModel.ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                  ),
                  child: Text('⚫️ ' + recipeModel.ingredients[index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Colors.black.withOpacity(0.3));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Preparations extends StatelessWidget {
  const Preparations({
    Key? key,
    required this.recipeModel,
  }) : super(key: key);

  final RecipeModel recipeModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: recipeModel.preparations.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                  ),
                  child: Text('⚫️ ' + recipeModel.preparations[index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Colors.black.withOpacity(0.3));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Links extends StatelessWidget {
  const Links({
    Key? key,
    required this.recipeModel,
  }) : super(key: key);

  final RecipeModel recipeModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Link(
          target: LinkTarget.blank,
          uri: Uri.parse(recipeModel.url),
          builder: (context, followLink) => InkWell(
              onTap: followLink,
              child: Text(
                recipeModel.url,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
              )),
          )
        )
      ),
    );
  }
}
