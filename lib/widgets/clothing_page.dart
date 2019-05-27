import 'dart:io';

import 'package:di_container/di_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suit_up/models/category.dart';
import 'package:suit_up/repository/repository.dart';

import 'image_picker_fab.dart';
import 'items_list.dart';

Future startClothingPage(BuildContext context, Category category) async {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) => _ClothingWidget(category),
  ));
}

class _ClothingWidget extends StatefulWidget {
  final category;

  _ClothingWidget(this.category);

  @override
  _ClothingWidgetState createState() => _ClothingWidgetState(category);
}

class _ClothingWidgetState extends State<_ClothingWidget> {
  ScrollController _scrollController;
  final category;

  _ClothingWidgetState(this.category);

  File _image;
  var imagePath;
  String flutterLogoFileName = "flutter.png";

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = dir.path + "/" + "image1.jpg";
    final newFile = File(pathName);
    final File newImage = await image.copy(newFile.path);

    SharedPreferences prefs = Injector.get();
    prefs.setString("image", newImage.path);

    setState(() {
      _image = newImage;
    });
  }

  @override
  void initState() {
    _scrollController = new ScrollController();
    _scrollController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: <Widget>[
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(color: Colors.black, opacity: 0),
                  backgroundColor: Colors.white,
                  expandedHeight: 140.0,
                  floating: true,
                  pinned: false,
                  snap: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: category.name,
                      child: Image.asset(category.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ];
            },
            body: ItemsList(Repository.instance.dress),
          ),
          _buildFab(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildFab() {
    final double defaultTopMargin = 120.0 - 4.0;
    final double scaleStart = 96.0;
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        scale = 0.0;
      }
    }

    return new Positioned(
      top: top,
      right: 16.0,
      child: new Transform(
          transform: new Matrix4.identity()..scale(scale), alignment: Alignment.center, child: ImagePickerFAB()),
    );
  }
}
