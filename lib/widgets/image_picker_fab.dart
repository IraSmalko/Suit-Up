import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerFAB extends StatefulWidget {
  @override
  _ImagePickerFABState createState() => _ImagePickerFABState();
}

class _ImagePickerFABState extends State<ImagePickerFAB> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<Color> _iconColor;
  Animation<IconData> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  double _padding = 8.0;

  File _image;

  pickImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = image;
    });
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

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget pickImageFromGallery() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          pickImage(ImageSource.gallery);
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

  Widget pickImageFromCamera() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          pickImage(ImageSource.camera);
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

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
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
          child: pickImageFromGallery(),
        ),
        Transform(
          transformHitTests: true,
          transform: Matrix4.translationValues(
            _translateButton.value,
            0.0,
            0.0,
          ),
          child: pickImageFromCamera(),
        ),
        toggle(),
      ],
    );
  }
}
