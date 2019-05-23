import 'package:flutter/material.dart';
import 'package:suit_up/models/category.dart';

import 'camera.dart';

class ListViewBuilder extends StatefulWidget {
  List<Category> entries;

  ListViewBuilder(this.entries);

  @override
  _ListViewBuilderState createState() => _ListViewBuilderState(entries);
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  List<Category> entries;

  _ListViewBuilderState(this.entries);

  @override
  Widget build(BuildContext context) {
    final numItems = entries.length;

    Widget _buildRow(int idx) {
      return GestureDetector(
        onTap: () {
          CameraPage.startCamera(context, entries[idx].imageUrl);
        },
        child: Card(
          child: Row(
            children: <Widget>[
              Container(height: 80, child: Image.network(entries[idx].imageUrl)),
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  entries[idx].name,
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
