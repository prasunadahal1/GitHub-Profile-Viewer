import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FirstProvider extends ChangeNotifier{
  late bool _isVisible=false;
  bool get isVisible=> _isVisible;
 void visible(){
    _isVisible = !_isVisible;
    print('hello');
    notifyListeners();
 }
}