import 'package:flutter/material.dart';
import 'package:suit_up/models/category.dart';
import 'package:suit_up/widgets/page_views.dart';

class ItemsList extends StatefulWidget {
  final List<Category> categories;

  ItemsList(this.categories);

  @override
  _ItemsListState createState() => _ItemsListState(categories);
}

class _ItemsListState extends State<ItemsList> {
  final List<Category> categories;

  _ItemsListState(this.categories);

  @override
  Widget build(BuildContext context) {
    final numItems = categories.length;

    Widget _buildRow(int idx) {
      return GestureDetector(
        onTap: () => startPageViews(context),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Column(
              children: <Widget>[
                Image.asset(categories[idx].imageUrl, fit: BoxFit.fill),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      itemCount: numItems,
      padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
      itemBuilder: (BuildContext context, int i) {
        return _buildRow(i);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
  }
}
