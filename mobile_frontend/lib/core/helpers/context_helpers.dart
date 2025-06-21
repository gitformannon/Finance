import 'package:flutter/widgets.dart';

class ContextHelper {
  ContextHelper._();

  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
