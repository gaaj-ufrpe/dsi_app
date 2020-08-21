import 'dart:math';

import 'package:dsi_app/constants.dart';
import 'package:dsi_app/infra.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: Icon(Icons.menu),
      title: Text('Home'),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.search),
        ),
        Icon(Icons.more_vert),
      ],
    );
  }

  Widget _buildBody() {
    return Opacity(
      opacity: 0.5,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff7ffe8), Color(0xffc2ca94)], // Color(0xffc7ffba)
            stops: [0.8, 1.0],
            transform: GradientRotation(pi / 2.03),
          ),
          image: DecorationImage(
            image: Images.bsiLogo,
          ),
        ),
      ),
    );
  }
}
