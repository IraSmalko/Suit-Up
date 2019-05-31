import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

startSPage(BuildContext context, Image path) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) => _SPage(path),
  ));
}

class _SPage extends StatelessWidget {
  final Image data;

  _SPage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
      child: Center(
        child: data,
      ),
    );
  }
}

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
  List<Offset> cropPoints = <Offset>[];
  List<Offset> erasePoints = <Offset>[];
  int _cIndex = 0;
  double sliderValue = 1.0;

  GlobalKey _globalKey = new GlobalKey();

  _capturePng(BuildContext context) async {
    try {
      print('inside');
      RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      var file = File.fromRawPath(pngBytes);
      var im = Image.memory(pngBytes);
      print(file);
      Directory dir = await getApplicationDocumentsDirectory();
      String pathName = dir.path + "/" + "image2.png";
      final newFile = File(pathName);
      //  final File newImage = await file.copy(newFile.path);
      startSPage(context, im);
    } catch (e) {
      print(e);
    }
  }

  void _incrementTab(index) {
    setState(() => _cIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final appData = MediaQuery.of(context).size;
    final paddingTop = MediaQuery.of(context).padding.top;
    final Container sketchArea = Container(
        alignment: Alignment.topLeft,
        color: Colors.transparent,
        child: CustomPaint(
          painter: Sketcher(cropPoints, erasePoints, data, appData.width, _cIndex, sliderValue),
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
                onPanDown: (DragDownDetails details) {
                  setState(() {
                    print("TTT  onPanDown");
                    if (_cIndex == 2) erasePoints = List.from(erasePoints)..add(details.globalPosition);
                  });
                },
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    print("TTT  onPanUpdate");
                    RenderBox box = context.findRenderObject();
                    Offset point = box.globalToLocal(details.globalPosition);
                    // point = point.translate(0.0, -(AppBar().preferredSize.height));
                    if (_cIndex == 1)
                      cropPoints = List.from(cropPoints)..add(point);
                    else if (_cIndex == 2) erasePoints = List.from(erasePoints)..add(details.globalPosition);
                  });
                },
                onPanEnd: (DragEndDetails details) {
                  setState(() {
                    if (_cIndex == 1) cropPoints = List.from(cropPoints)..add(null);
                  });
                },
                child: RepaintBoundary(key: _globalKey, child: sketchArea),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Slider(
                activeColor: Colors.black,
                min: 0.0,
                max: 15.0,
                divisions: 15,
                value: sliderValue,
                label: "${sliderValue.round()}",
                onChanged: (double value) {
                  setState(() => sliderValue = value);
                },
              ),
            ),
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
          if (0 == index) {
            _capturePng(context);
          } else if (3 == index) {
            setState(() {
              cropPoints.clear();
              erasePoints.clear();
            });
          }
        },
      ),
    );
  }

  _SketcherPageState(this.data);
}

class Sketcher extends CustomPainter {
  ui.Image image;
  List<Offset> cropPoints;
  final List<Offset> erasePoints;
  final double appWidth;
  final double paintWidth;
  final int buttonIndex;

  Sketcher(this.cropPoints, this.erasePoints, this.image, this.appWidth, this.buttonIndex, this.paintWidth);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
    // return oldDelegate.points != points;
  }

  @override
  paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, appWidth, appWidth));

    var cropPath = Path();
    Paint paintCropLine = Paint()..blendMode = BlendMode.clear;

    for (int i = 0; i < cropPoints.length; i++) {
      if (cropPoints[i] == null) {
        cropPoints.removeLast();
        cropPath.addPolygon(cropPoints, true);
        canvas.clipPath(cropPath);
        cropPoints.add(null);
      }
    }

    canvas.drawImageNine(
      image,
      Rect.fromCenter(center: Offset(0, 0), width: appWidth, height: appWidth),
      Rect.fromLTWH(16, 16, appWidth - 32, appWidth - 32),
      Paint(),
    );

    erase(canvas);

    for (int i = 0; i < cropPoints.length; i++) {
      if (cropPoints[i] != null && cropPoints[i + 1] != null) {
        canvas.drawLine(cropPoints[i], cropPoints[i + 1], paintCropLine);
      }
    }
  }

  erase(Canvas canvas) {
    Paint erasePaint = Paint()
      ..color = Colors.white
      ..blendMode = BlendMode.clear;

    for (int i = 0; i < erasePoints.length; i++) {
      canvas.drawOval(Rect.fromCircle(center: erasePoints[i], radius: paintWidth), erasePaint);
    }
  }
}
