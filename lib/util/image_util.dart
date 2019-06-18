import 'dart:ui' as ui;

import 'package:flutter/services.dart';

Future<ui.FrameInfo> loadImage(String pathName) async {
  var q = await rootBundle.load(pathName);
  if (q == null) throw 'Unable to read data';
  var codec = await ui.instantiateImageCodec(q.buffer.asUint8List());

  return await codec.getNextFrame();
}
