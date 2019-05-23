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
  final List<CameraDescription> cameras;
  final url;

  _CameraWidget(this.cameras, this.url);

  @override
  _CameraWidgetState createState() => _CameraWidgetState(cameras, url);
}

class _CameraWidgetState extends State<_CameraWidget> {
  List<CameraDescription> cameras;
  CameraController controller;
  final url;

  _CameraWidgetState(this.cameras, this.url);

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          children: <Widget>[
            CameraPreview(controller),
            PinchZoomImage(
              image: Image.network(url),
              zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
              hideStatusBarWhileZooming: true,
            )
          ],
        ));
  }
}
