import 'package:flutter/material.dart';
import 'package:suit_up/models/category.dart';

import 'clothing_page.dart';

class ListViewBuilder extends StatefulWidget {
  final List<Category> categories;

  ListViewBuilder(this.categories);

  @override
  _ListViewBuilderState createState() => _ListViewBuilderState(categories);
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  final List<Category> categories;

  _ListViewBuilderState(this.categories);

  @override
  Widget build(BuildContext context) {
    final numItems = categories.length;

    Widget _buildRow(int idx) {
      return GestureDetector(
        onTap: () => startClothingPage(context, categories[idx]),
        child: Card(
          child: Row(
            children: <Widget>[
              Hero(
                tag: categories[idx].name,
                child: Container(
                  height: 70,
                  width: 120,
                  child: Image.asset(categories[idx].imageUrl),
                ),
              ),
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  categories[idx].name,
                  style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: numItems,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int i) {
        return _buildRow(i);
      },
    );
  }
}
