import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'item_page.dart';

startSketcherPage(BuildContext context, ui.Image data) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) => SketcherPage(data),
  ));
}

class SketcherPage extends StatefulWidget {
  final ui.Image _data;

  SketcherPage(this._data);

  @override
  _SketcherPageState createState() => _SketcherPageState(_data);
}

class _SketcherPageState extends State<SketcherPage> {
  final ui.Image _data;
  final GlobalKey _globalKey = GlobalKey();
  List<Offset> _cropPoints = <Offset>[];
  List<Offset> _erasePoints = <Offset>[];

  Offset _startingFocalPoint;
  Offset _previousOffset;
  Offset _offset = Offset.zero;
  double _previousZoom;
  double _zoom = 1.0;
  bool _scaleEnabled = true;
  int _cIndex = 0;
  double _sliderValue = 1.0;

  void _capturePng(BuildContext context) async {
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
      startItemPage(context, im);
    } catch (e) {
      print(e);
    }
  }

  void _incrementTab(index) {
    setState(() => _cIndex = index);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    setState(() {
      _startingFocalPoint = details.focalPoint;
      _previousOffset = _offset;
      _previousZoom = _zoom;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _zoom = _previousZoom * details.scale;

      final Offset normalizedOffset = (_startingFocalPoint - _previousOffset) / _previousZoom;
      _offset = details.focalPoint - normalizedOffset * _zoom;
    });
  }

  void _handleScaleReset() {
    setState(() {
      _zoom = 1.0;
      _offset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appData = MediaQuery.of(context).size;
    final paddingTop = MediaQuery.of(context).padding.top;
    final Container sketchArea = Container(
        alignment: Alignment.topLeft,
        color: Colors.transparent,
        child: CustomPaint(
          painter: Sketcher(_zoom, _offset, _cropPoints, _erasePoints, _data, appData.width, _sliderValue),
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
              color: Colors.black,
              height: appData.height - appData.width / 2,
              child: GestureDetector(
                onScaleStart: _scaleEnabled ? _handleScaleStart : null,
                onScaleUpdate: _scaleEnabled ? _handleScaleUpdate : null,
                child: GestureDetector(
                  onPanDown: (DragDownDetails details) {
                    setState(() {
                      if (_cIndex == 2) _erasePoints = List.from(_erasePoints)..add(details.globalPosition);
                    });
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    setState(() {
                      if (_cIndex == 1)
                        _cropPoints = List.from(_cropPoints)..add(details.globalPosition);
                      else if (_cIndex == 2) _erasePoints = List.from(_erasePoints)..add(details.globalPosition);
                    });
                  },
                  onPanEnd: (DragEndDetails details) {
                    setState(() {
                      if (_cIndex == 1) _cropPoints = List.from(_cropPoints)..add(null);
                    });
                  },
                  child: RepaintBoundary(key: _globalKey, child: sketchArea),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Slider(
                activeColor: Colors.black,
                min: 0.0,
                max: 15.0,
                divisions: 15,
                value: _sliderValue,
                label: "${_sliderValue.round()}",
                onChanged: (double value) {
                  setState(() => _sliderValue = value);
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
          BottomNavigationBarItem(
              icon: Icon(Icons.restore, color: Color.fromARGB(255, 0, 0, 0)), title: Text('Restore')),
          BottomNavigationBarItem(icon: Icon(Icons.done, color: Color.fromARGB(255, 0, 0, 0)), title: Text('Done')),
          //   BottomNavigationBarItem(icon: Icon(Icons.refresh, color: Color.fromARGB(255, 0, 0, 0)), title: Text('Rotate'))
        ],
        onTap: (index) {
          _incrementTab(index);
          switch (index) {
            case 0:
              _scaleEnabled = true;
              break;
            case 1:
              _scaleEnabled = false;
              break;
            case 2:
              _scaleEnabled = false;
              break;
            case 3:
              setState(() {
                _scaleEnabled = false;
                _cropPoints.clear();
                _erasePoints.clear();
                _handleScaleReset();
              });
              break;
            case 4:
              _capturePng(context);
              break;
          }
        },
      ),
    );
  }

  _SketcherPageState(this._data);
}

class Sketcher extends CustomPainter {
  final ui.Image _image;
  final List<Offset> _cropPoints;
  final List<Offset> _erasePoints;
  final double _appWidth;
  final double _paintWidth;
  final double _zoom;
  final Offset _offset;

  final Path cropPath = Path();
  final Rect dstRect = Rect.fromCenter(center: Offset(0, 0), width: 0, height: 0);
  final Paint paintCropLine = Paint()..blendMode = BlendMode.clear;
  final Paint paintImage = Paint()..filterQuality = FilterQuality.medium;
  final Paint erasePaint = Paint()
    ..color = Colors.white
    ..blendMode = BlendMode.clear;

  Sketcher(
    this._zoom,
    this._offset,
    this._cropPoints,
    this._erasePoints,
    this._image,
    this._appWidth,
    this._paintWidth,
  );

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
    // return oldDelegate.points != points;
  }

  @override
  paint(Canvas canvas, Size size) {
    var height = _image.height * _appWidth / _image.width;

    for (int i = 0; i < _cropPoints.length; i++) {
      if (_cropPoints[i] == null) {
        _cropPoints.removeLast();
        cropPath.addPolygon(_cropPoints, true);
        canvas.clipPath(cropPath);
        _cropPoints.add(null);
      }
    }

    canvas.drawImageNine(
      _image,
      dstRect,
      Rect.fromLTWH(24 * _zoom + _offset.dx, 24 * _zoom + _offset.dy, (_appWidth - 48) * _zoom, (height - 48) * _zoom),
      paintImage,
    );

    for (int i = 0; i < _erasePoints.length; i++) {
      canvas.drawOval(Rect.fromCircle(center: _erasePoints[i], radius: _paintWidth), erasePaint);
    }

    for (int i = 0; i < _cropPoints.length; i++) {
      if (_cropPoints[i] != null && _cropPoints[i + 1] != null) {
        canvas.drawLine(_cropPoints[i], _cropPoints[i + 1], paintCropLine);
      }
    }
  }
}
