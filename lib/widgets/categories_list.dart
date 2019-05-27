import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:suit_up/models/category.dart';

import 'clothing_page.dart';

class CategoriesList extends StatefulWidget {
  final List<Category> categories;

  CategoriesList(this.categories);

  @override
  _CategoriesListState createState() => _CategoriesListState(categories);
}

class _CategoriesListState extends State<CategoriesList> {
  final List<Category> categories;

  _CategoriesListState(this.categories);

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
                  height: 72,
                  width: 140,
                  child: Image.asset(categories[idx].imageUrl),
                ),
              ),
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 30.0,
                      maxWidth: 300.0,
                      minHeight: 30.0,
                      maxHeight: 100.0,
                    ),
                    child: AutoSizeText(
                      categories[idx].name,
                      style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
                    ),
                  ),
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
