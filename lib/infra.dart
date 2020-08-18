import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Size getSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

abstract class AbstractDsiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: getSize(context).height,
            child: buildBody(context),
          ),
        ),
      ),
    );
  }

  @protected
  Widget buildBody(BuildContext context);
}
