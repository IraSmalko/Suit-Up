import 'package:flutter/material.dart';

startItemPage(BuildContext context, Image path) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) => _ItemPage(path),
  ));
}

class _ItemPage extends StatelessWidget {
  final Image data;

  _ItemPage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: data,
      ),
    );
  }
}
