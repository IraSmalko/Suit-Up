import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suit_up/models/category.dart';
import 'package:suit_up/repository/repository.dart';

startPageViews(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) => PageViews(),
  ));
}

class PageViews extends StatefulWidget {
  @override
  _PageViewsState createState() => _PageViewsState();
}

class _PageViewsState extends State<PageViews> {
  PageController _controller;
  double _currentPageValue = 0.0;
  static final List<Category> _items = Repository.instance.dress;

  @override
  void initState() {
    _controller = PageController()
      ..addListener(() {
        setState(() {
          _currentPageValue = _controller.page;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    var screenWidth = data.size.width - data.padding.horizontal;

    return Scaffold(
      primary: true,
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.black, opacity: 1),
        backgroundColor: Colors.white,
        title: Text("Suit up", style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic)),
      ),
      body: PageView.builder(
        controller: _controller,
        itemBuilder: (context, position) {
          return Transform(
            transform: Matrix4.identity()
              ..rotateY(_currentPageValue - position)
              ..rotateZ(_currentPageValue - position),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    child: Image.asset(_items[position].imageUrl),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    "Some description",
                    style: TextStyle(color: Colors.black, fontSize: 22.0),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: _items.length,
      ),
    );
  }
}
