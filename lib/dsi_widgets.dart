import 'dart:math';

import 'package:dsi_app/constants.dart';
import 'package:dsi_app/infra.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final dsiDialog = _DsiDialog();

class _DsiDialog {
  void showInfo(
      {@required context,
      title = 'Sucesso',
      message = 'Operação realizada com sucesso.',
      buttonLabel = 'Fechar',
      buttonPressed}) {
    var dialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text(buttonLabel),
          onPressed: () {
            if (buttonPressed != null) {
              buttonPressed();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
    showDialog(context: context, child: dialog);
  }
}

/// Este Scaffold é customizado para incluir o 'body' dentro de um scrollview,
/// evitando o overflow da tela, em telas maiores que o tamanho da tela do
/// aparelho. Esta primeira implementação considera apenas o Scaffold com o
/// parâmetro 'body'
class DsiScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget floatingActionButton;

  //Na definição do parâmetro {@required this.body}, as chaves indicam que o
  //parâmetro é nominal (named parameter) e a anotação @required indica que o
  //parâmetro é obrigatório.
  DsiScaffold({@required this.body, this.title, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildSideMenu(context),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: dsiHelper.getBodyHeight(context),
            child: this.body,
          ),
        ),
      ),
      floatingActionButton: this.floatingActionButton,
    );
  }

  Drawer _buildSideMenu(context) {
    var themeData = Theme.of(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          _buildSideMenuHeader(context, themeData),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => dsiHelper.go(context, '/home'),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () => dsiHelper.exit(context),
          ),
        ],
      ),
    );
  }

  DrawerHeader _buildSideMenuHeader(context, themeData) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [themeData.backgroundColor, themeData.primaryColor],
          transform: GradientRotation(pi / 2.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Image(
              image: Images.bsiLogo,
              height: 36.0,
              alignment: Alignment.bottomCenter,
              color: Constants.colorGreenBSI2,
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Text(
            'DSI App',
            style: themeData.textTheme.headline1.copyWith(
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
              color: Constants.colorGreenBSI3,
            ),
          ),
          Spacer(
            flex: 3,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '''por Gabriel Alves\n'''
              '''contato: gabriel.alves@ufrpe.br''',
              textAlign: TextAlign.right,
              style: themeData.textTheme.caption.copyWith(
                fontSize: 12.0,
                color: Constants.colorGreenBSI2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(context) {
    if (title == null) return null;
    //quando informa o drawer do scaffold, não se informa o leading do AppBar.
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(
          onPressed: () => print('search'),
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () => print('notifications'),
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onSelected: (value) => {
            if (value == 'sair')
              dsiHelper.exit(context)
            else if (value == 'pref')
              dsiDialog.showInfo(context: context, message: 'Falta implementar')
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: Text('Preferências'),
              value: 'pref',
            ),
            PopupMenuItem(
              child: Text('Sair'),
              value: 'sair',
            ),
          ],
        ),
      ],
    );
  }
}
