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

  void go(context, page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void back(context) {
    Navigator.pop(context);
  }
}

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
  final Widget appBar;
  final Widget body;
  final Widget floatingActionButton;

  //Na definição do parâmetro {@required this.body}, as chaves indicam que o
  //parâmetro é nominal (named parameter) e a anotação @required indica que o
  //parâmetro é obrigatório.
  DsiScaffold({@required this.body, this.appBar, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this.appBar,
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
}
