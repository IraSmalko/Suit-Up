import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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
    return oldDelegate._zoom != _zoom || oldDelegate._offset != _offset || oldDelegate._image != _image;
  }

  @override
  paint(Canvas canvas, Size size) {
    var height = _image.height * _appWidth / _image.width;

    canvas.drawImageNine(
      _image,
      dstRect,
      Rect.fromLTWH(24 * _zoom + _offset.dx, 24 * _zoom + _offset.dy, (_appWidth - 48) * _zoom, (height - 48) * _zoom),
      paintImage,
    );
  }
}
