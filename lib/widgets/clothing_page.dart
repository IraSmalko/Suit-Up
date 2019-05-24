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
  ScrollController _scrollController;
  final category;

  _ClothingWidgetState(this.category);

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _scrollController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: new Stack(
        children: <Widget>[
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(color: Colors.black, opacity: 0),
                  backgroundColor: Colors.white,
                  expandedHeight: 120.0,
                  floating: true,
                  pinned: false,
                  snap: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: category.name,
                      child: Image.asset(category.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ];
            },
            body: Text("tefd"),
          ),
          _buildFab(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildFab() {
    final double defaultTopMargin = 120.0 - 4.0;
    final double scaleStart = 96.0;
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        scale = 0.0;
      }
    }

    return new Positioned(
      top: top,
      right: 16.0,
      child: new Transform(
        transform: new Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: new FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () => {},
          child: new Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
