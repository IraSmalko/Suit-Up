import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';

Future startCamera(BuildContext context, String url) async {
  List<CameraDescription> cameras = await availableCameras();
  Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) => _CameraWidget(cameras, url),
  ));
}

class _CameraWidget extends StatefulWidget {
  final List<CameraDescription> _cameras;
  final _url;

  _CameraWidget(this._cameras, this._url);

  @override
  _CameraWidgetState createState() => _CameraWidgetState(_cameras, _url);
}

class _CameraWidgetState extends State<_CameraWidget> {
  CameraController _controller;
  final List<CameraDescription> _cameras;
  final _url;

  _CameraWidgetState(this._cameras, this._url);

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
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          children: <Widget>[
            CameraPreview(_controller),
            PinchZoomImage(
              image: Image.network(_url),
              zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
              hideStatusBarWhileZooming: true,
            )
          ],
        ));
  }
}
