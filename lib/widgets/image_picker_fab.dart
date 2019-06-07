import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:suit_up/widgets/sketcher_page.dart';

class ImagePickerFAB extends StatefulWidget {
  @override
  _ImagePickerFABState createState() => _ImagePickerFABState();
}

class _ImagePickerFABState extends State<ImagePickerFAB> with SingleTickerProviderStateMixin {
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;
  final double _padding = 8.0;

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<Color> _iconColor;
  Animation<IconData> _animateIcon;
  Animation<double> _translateButton;

  void _pickImage(ImageSource source, BuildContext context) async {
    var image = await ImagePicker.pickImage(source: source);

    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = dir.path + "/" + "image1.jpg";
    final newFile = File(pathName);
    final File newImage = await image.copy(newFile.path);

    _loadImage(pathName).then((_) => startSketcherPage(context, _.image));
  }

  Future<ui.FrameInfo> _loadImage(String pathName) async {
    var q = await rootBundle.load(pathName);
    if (q == null) throw 'Unable to read data';
    var codec = await ui.instantiateImageCodec(q.buffer.asUint8List());

    return await codec.getNextFrame();
  }

  @override
  initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon = Tween<IconData>(begin: Icons.add, end: Icons.close).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.00,
          0.00,
          curve: Curves.linear,
        ),
      ),
    );
    _buttonColor = ColorTween(
      begin: Colors.white,
      end: Colors.redAccent,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _iconColor = ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: _padding,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget _pickImageFromGallery(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          _pickImage(ImageSource.gallery, context);
        },
        backgroundColor: Colors.white,
        tooltip: "pickImageFromGallery",
        heroTag: "pickImageFromGallery'",
        child: Icon(
          Icons.photo_library,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _pickImageFromCamera(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          _pickImage(ImageSource.camera, context);
        },
        backgroundColor: Colors.white,
        tooltip: "pickImageFromCamera",
        heroTag: "pickImageFromCamera",
        child: Icon(
          Icons.camera_alt,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: _animate,
        tooltip: 'Toggle',
        child: Icon(
          _animateIcon.value,
          color: _iconColor.value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transformHitTests: true,
          transform: Matrix4.translationValues(
            _translateButton.value * 2.0,
            0.0,
            0.0,
          ),
          child: _pickImageFromGallery(context),
        ),
        Transform(
          transformHitTests: true,
          transform: Matrix4.translationValues(
            _translateButton.value,
            0.0,
            0.0,
          ),
          child: _pickImageFromCamera(context),
        ),
        _toggle(),
      ],
    );
  }
}
