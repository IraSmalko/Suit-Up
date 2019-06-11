import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZoomImageView extends StatefulWidget {
  final ui.Image _image;

  ZoomImageView(this._image);

  @override
  _ZoomImageViewState createState() => _ZoomImageViewState(this._image);
}

class _ZoomImageViewState extends State<ZoomImageView> {
  Offset _startingFocalPoint;
  Offset _previousOffset;
  Offset _offset = Offset.zero;
  double _previousZoom;
  double _zoom = 1.0;
  final ui.Image _image;

  _ZoomImageViewState(this._image);

  @override
  Widget build(BuildContext context) {
    final appData = MediaQuery.of(context).size;
    print("QQQ build $_zoom");

    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      child: CustomPaint(
        painter: ZoomPainter(_zoom, _offset, _image, appData.width),
      ),
    );
  }

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
