import 'package:flutter/material.dart';
import 'package:vegan_recipes/NewRecipe.dart';
import 'package:vegan_recipes/LikeRecipe.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int pageIndex = 0;
  final pages = [
  const Page1(),
  const Page2(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FlutterIcons.seedling_faw5s,color: Colors.black,),
            SizedBox(width: 10),
            Text('Vegan Recipe',style: TextStyle(color: Colors.black),),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        // color: Colors.grey[300],
        height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 0;
                  });
                },
                icon: pageIndex == 0
                    ? const Icon(
                  Icons.home_filled,
                )
                    : const Icon(
                  Icons.home_outlined,
                ),
              ),
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 1;
                  });
                },
                icon: pageIndex == 1
                    ? const Icon(
                  Icons.favorite
                )
                    : const Icon(
                  Icons.favorite_border_outlined
                ),
              ),
            ],
          ),
        ),
      body: pages[pageIndex],
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: DefaultTabController(
        length: 1,
        initialIndex: 0,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TabBar(
              isScrollable: true,
              indicatorColor: Colors.red,
              tabs: [
                Tab(
                  text: "New Recipes".toUpperCase(),
                ),
              ],
              labelColor: Colors.black,
              indicator: DotIndicator(
                color: Colors.black,
                distanceFromCenter: 16,
                radius: 3,
                paintingStyle: PaintingStyle.fill,
              ),
              unselectedLabelColor: Colors.black.withOpacity(0.3),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              labelPadding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  NewRecipe(),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: LikeRecipe(),
      );
    }
}

