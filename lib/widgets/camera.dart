import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future startCamera(BuildContext context, String url) async {
  List<CameraDescription> cameras = await availableCameras();
  _loadImage(url).then((val) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => _CameraWidget(cameras, val.image),
    ));
  });
}
//Future startZoom(BuildContext context, String url) async {
//  List<CameraDescription> cameras = await availableCameras();
//  _loadImage(url).then((val) {
//    Navigator.of(context).push(MaterialPageRoute(
//      builder: (BuildContext context) => ZoomImageView( val.image),
//    ));
//  });
//}

Future<ui.FrameInfo> _loadImage(String pathName) async {
  var q = await rootBundle.load(pathName);
  if (q == null) throw 'Unable to read data';
  var codec = await ui.instantiateImageCodec(q.buffer.asUint8List());

  return await codec.getNextFrame();
}

class _CameraWidget extends StatefulWidget {
  final List<CameraDescription> _cameras;
  final ui.Image _image;

  _CameraWidget(this._cameras, this._image);

  @override
  _CameraWidgetState createState() => _CameraWidgetState(_cameras, _image);
}

class _CameraWidgetState extends State<_CameraWidget> {
  CameraController _controller;
  final List<CameraDescription> _cameras;
  final ui.Image _image;

  _CameraWidgetState(this._cameras, this._image);

  @override
  void initState() {
    super.initState();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appData = MediaQuery.of(context).size;
    print("QQQ build $_zoom");
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: GestureDetector(
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            child: Stack(
              children: <Widget>[
                CameraPreview(_controller),
                CustomPaint(
                  painter: ZoomPainter(_zoom, _offset, _image, appData.width),
                ),
              ],
            )));
  }

  Offset _startingFocalPoint;
  Offset _previousOffset;
  Offset _offset = Offset.zero;
  double _previousZoom;
  double _zoom = 1.0;
  // final ui.Image _image;

//    @override
//    Widget build(BuildContext context) {
//      final appData = MediaQuery.of(context).size;
//      print("QQQ build $_zoom");
//
//      return GestureDetector(
//        onScaleStart: _handleScaleStart,
//        onScaleUpdate: _handleScaleUpdate,
//        child: CustomPaint(
//          painter: ZoomPainter(_zoom, _offset, _image, appData.width),
//        ),
//      );
//    }

  void _handleScaleStart(ScaleStartDetails details) {
    print("QQQ handleScaleStart $_zoom");
    setState(() {
      _startingFocalPoint = details.focalPoint;
      _previousOffset = _offset;
      _previousZoom = _zoom;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    print("QQQ handleScaleUpdate $_zoom");
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
}

class ZoomPainter extends CustomPainter {
  final ui.Image _image;
  final double _zoom;
  final double _appWidth;
  final Offset _offset;

  final Rect dstRect = Rect.fromCenter(center: Offset(0, 0), width: 0, height: 0);
  final Paint paintImage = Paint()..filterQuality = FilterQuality.medium;

  ZoomPainter(this._zoom, this._offset, this._image, this._appWidth);

  @override
  bool shouldRepaint(ZoomPainter oldDelegate) {
    return true;
    // return oldDelegate._zoom != _zoom && oldDelegate._offset != _offset && oldDelegate._image != _image;
  }

  @override
  paint(Canvas canvas, Size size) {
    var height = _image.height * _appWidth / _image.width;
    print("QQQ zoom $_zoom");

    canvas.drawImageNine(
      _image,
      dstRect,
      Rect.fromLTWH(24 * _zoom + _offset.dx, 24 * _zoom + _offset.dy, (_appWidth - 48) * _zoom, (height - 48) * _zoom),
      paintImage,
    );
  }
}
