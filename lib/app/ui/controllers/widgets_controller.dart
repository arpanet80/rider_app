import 'package:flutter/cupertino.dart';

class CambiaVisible with ChangeNotifier {
  bool _visible = true;

  bool get visible => _visible;

  void cambiaEstado() {
    _visible ? _visible = false : _visible = false;
    notifyListeners();
  }
}
