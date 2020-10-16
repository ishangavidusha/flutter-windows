

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as im;

class ImageService with ChangeNotifier {
  im.Image _image;
  im.Image _original;
  int _width;
  int _height;
  bool _loading = false;

  void setImage(im.Image image) {
    _image = im.copyResize(image, width: image.height);
    _original = _image;
    _width = _image.width;
    _height = _image.height;
    notifyListeners();
  }

  int get width => _width;
  int get height => _height;
  bool get loading => _loading;

  Uint8List getImage() {
    return im.encodeJpg(_image);
  }

  Map<String, dynamic> resize(int width, int height) {
    working(true);
    _image = im.copyResize(_original, width: width, height: height);
    _width = _image.width;
    _height = _image.height;
    working(false);
    return { "width" : _width, "height" : _height};
  }

  void rotate(num angle) {
    working(true);
    _image = im.copyRotate(_image, angle);
    _original = _image;
    _width = _image.width;
    _height = _image.height;
    working(false);
  }

  void crop(int x, int y, int width, int height) {
    working(true);
    _image = im.copyCrop(_image, x, y, width, height);
    _width = _image.width;
    _height = _image.height;
    working(false);
  }

  void working(bool value) {
    if (value == true) {
      _loading = true;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }

}