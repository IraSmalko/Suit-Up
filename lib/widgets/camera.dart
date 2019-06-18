import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:suit_up/util/image_util.dart';
import 'package:suit_up/widgets/zoom_painter.dart';

Future startCamera(BuildContext context, String url) async {
  List<CameraDescription> cameras = await availableCameras();
  loadImage(url).then((val) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => _CameraWidget(cameras, val.image),
    ));
  });
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

  Offset _startingFocalPoint;
  Offset _previousOffset;
  Offset _offset = Offset.zero;
  double _previousZoom;
  double _zoom = 1.0;

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

  _handleScaleStart(ScaleStartDetails details) {
    setState(() {
      _startingFocalPoint = details.focalPoint;
      _previousOffset = _offset;
      _previousZoom = _zoom;
    });
  }

  _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _zoom = _previousZoom * details.scale;

      final Offset normalizedOffset = (_startingFocalPoint - _previousOffset) / _previousZoom;
      _offset = details.focalPoint - normalizedOffset * _zoom;
    });
  }

  _handleScaleReset() {
    setState(() {
      _zoom = 1.0;
      _offset = Offset.zero;
    });
  }
}
