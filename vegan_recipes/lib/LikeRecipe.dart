import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vegan_recipes/Screens/LikeDetails.dart';
import 'NewRecipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikeRecipe extends StatefulWidget {
  @override
  State<LikeRecipe> createState() => _LikeRecipeState();
}

class _LikeRecipeState extends State<LikeRecipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
        padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
    ),
    child: StreamBuilder<List<Fav>>(
      stream: readFavs(),
      builder: (context, snapshot) {
        //print(snapshot);
        if (snapshot.hasError) {
          return Text('Something went wrong!');
        } else if (snapshot.hasData) {
          final favs = snapshot.data!;

          List<Fav> recipe = favs.toList();
          return Scaffold(
                body : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: recipe.length,
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
                               builder: (context) => LikeDetails(
                                  fav: recipe[index],
                                ),
                              )),
                          child: LikeCard(
                            fav: recipe[index],
                          ),
                        )
                      );
                    },
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    )));
  }

  Stream<List<Fav>> readFavs() => FirebaseFirestore.instance
      .collection('favs')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Fav.fromJson(doc.data())).toList());
}

class LikeCard extends StatefulWidget {
  final Fav fav;
  LikeCard({
    required this.fav,
  });

  @override
  _LikeCardState createState() => _LikeCardState();
}

class _LikeCardState extends State<LikeCard> {
  bool saved = true;

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
                  tag: widget.fav.images,
                  child: Image(
                    height: 320,
                    width: 320,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.fav.images),
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
                    final docFav = FirebaseFirestore.instance
                    .collection('favs')
                    .doc(widget.fav.id);

                    docFav.delete();
                    //widget.fav.like = !widget.fav.like;
                  }
                  );
                },
                child: Icon(
                  saved
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
                      widget.fav.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle1,
                    ),
                    SizedBox(
                      height: 8,
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
                      width: 5,
                    ),
                    Icon(
                      FlutterIcons.timer_mco,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      ((widget.fav.totalTime) ~/ 60).toString() + '\'',
                    ),
                    Spacer(),
                    Icon(
                      FlutterIcons.md_star_ion,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      ((widget.fav.rating).toStringAsFixed(1)),
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