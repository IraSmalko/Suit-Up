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

  @override
  Widget build(BuildContext context) {
    final appData = MediaQuery.of(context).size;
    final paddingTop = MediaQuery.of(context).padding.top;
    final Container sketchArea = Container(
        margin: EdgeInsets.only(bottom: appData.height - appData.width - paddingTop),
        alignment: Alignment.topLeft,
        color: Colors.black,
        child: CustomPaint(
          painter: Sketcher(points, data, appData.width),
        ));

    return Scaffold(
      appBar: null,
      body: Container(
        margin: EdgeInsets.only(top: paddingTop),
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox box = context.findRenderObject();
              Offset point = box.globalToLocal(details.globalPosition);
              point = point.translate(0.0, -(AppBar().preferredSize.height));

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
      floatingActionButton: FloatingActionButton(
        tooltip: 'clear Screen',
        backgroundColor: Colors.red,
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() => points.clear());
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
