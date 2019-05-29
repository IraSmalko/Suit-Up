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
  PageController controller;
  var currentPageValue = 0.0;
  static final List<Category> items = Repository.instance.dress;

  @override
  void initState() {
    controller = PageController()
      ..addListener(() {
        setState(() {
          currentPageValue = controller.page;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    var screenWidth = data.size.width - data.padding.horizontal;
    data.size;
    return Scaffold(
      primary: true,
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.black, opacity: 1),
        backgroundColor: Colors.white,
        title: Text(
          "Suit up",
          style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
        ),
      ),
      body: PageView.builder(
        controller: controller,
        itemBuilder: (context, position) {
          return Transform(
            transform: Matrix4.identity()
              ..rotateY(currentPageValue - position)
              ..rotateZ(currentPageValue - position),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    child: Image.asset(items[position].imageUrl),
                  ),
                  Text(
                    "Page",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }
}
