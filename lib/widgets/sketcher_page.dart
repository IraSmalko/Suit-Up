import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

startSketcherPage(BuildContext context, ui.Image data) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) => SketcherPage(data),
  ));
}

class SketcherPage extends StatefulWidget {
  ui.Image data;

  @override
  _SketcherPageState createState() => _SketcherPageState(data);

  SketcherPage(this.data);
}

class _SketcherPageState extends State<SketcherPage> {
  final ui.Image data;
  List<Offset> points = <Offset>[];
  int _cIndex = 0;
  double sliderValue = 1.0;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appData = MediaQuery.of(context).size;
    final paddingTop = MediaQuery.of(context).padding.top;
    final Container sketchArea = Container(
        alignment: Alignment.topLeft,
        color: Colors.black,
        child: CustomPaint(
          painter: Sketcher(points, data, appData.width),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Container(
        margin: EdgeInsets.only(top: paddingTop),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: appData.width + paddingTop,
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    RenderBox box = context.findRenderObject();
                    Offset point = box.globalToLocal(details.globalPosition);
                    // point = point.translate(0.0, -(AppBar().preferredSize.height));

                    points = List.from(points)..add(point);
                  });
                },
                onPanEnd: (DragEndDetails details) {
                  setState(() {
                    points = List.from(points)..add(null);
                  });
                },
                child: sketchArea,
              ),
            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Slider(
//                activeColor: Colors.black,
//                min: 0.0,
//                max: 5.0,
//                divisions: 5,
//                value: sliderValue,
//                label: "${sliderValue.round()}",
//                onChanged: (double value) {
//                  setState(() => sliderValue = value);
//                },
//              ),
//            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        fixedColor: Colors.black,
        elevation: 5.0,
        currentIndex: _cIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.zoom_in, color: Color.fromARGB(255, 0, 0, 0)), title: Text('Zoom')),
          BottomNavigationBarItem(icon: Icon(Icons.crop, color: Color.fromARGB(255, 0, 0, 0)), title: Text('Crop')),
          BottomNavigationBarItem(icon: Icon(Icons.brush, color: Color.fromARGB(255, 0, 0, 0)), title: Text('Erase')),
          BottomNavigationBarItem(icon: Icon(Icons.refresh, color: Color.fromARGB(255, 0, 0, 0)), title: Text('Rotate'))
        ],
        onTap: (index) {
          _incrementTab(index);
          if (index == 3) {
            setState(() => points.clear());
          }
        },
      ),
    );
  }

  _SketcherPageState(this.data);
}

class Sketcher extends CustomPainter {
  ui.Image image;
  final List<Offset> points;
  final double appWidth;

  Sketcher(this.points, this.image, this.appWidth);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return oldDelegate.points != points;
  }

  @override
  paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length; i++) {
      if (points[i] == null) {
        points.removeLast();
        var path = Path();
        path.addPolygon(points, true);
        canvas.clipPath(path);
      }
    }

    canvas.drawImageNine(
      image,
      Rect.fromCenter(center: Offset(0, 0), width: 0, height: 0),
      Rect.fromLTWH(16, 16, appWidth - 32, appWidth - 32),
      Paint(),
    );

    for (int i = 0; i < points.length; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }
}
