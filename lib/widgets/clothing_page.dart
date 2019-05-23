import 'package:flutter/material.dart';
import 'package:suit_up/models/category.dart';

Future startClothingPage(BuildContext context, Category category) async {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) => _ClothingWidget(category),
  ));
}

class _ClothingWidget extends StatefulWidget {
  final category;

  _ClothingWidget(this.category);

  @override
  _ClothingWidgetState createState() => _ClothingWidgetState(category);
}

class _ClothingWidgetState extends State<_ClothingWidget> {
  final category;

  _ClothingWidgetState(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 120.0,
              floating: true,
              pinned: false,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                tag: category.name,
                child: Image.asset(
                  category.imageUrl,
                  fit: BoxFit.cover,
                ),
              )),
            ),
          ];
        },
        body: Text("text"),
      ),
    );
  }
}
