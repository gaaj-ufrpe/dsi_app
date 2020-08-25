import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final dsiHelper = _DsiHelper();

class _DsiHelper {
  Size getBodySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double getBodyHeight(BuildContext context) {
    return getBodySize(context).height;
  }

  double getBodyWidth(BuildContext context) {
    return getBodySize(context).width;
  }

  void go(context, routeName) {
    Navigator.pushNamed(context, routeName);
  }

  void back(context) {
    Navigator.pop(context);
  }

  void exit(context) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/', (Route<dynamic> route) => false);
  }
}
