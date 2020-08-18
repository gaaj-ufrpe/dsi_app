import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Size getSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

class DsiDialog {
  static void showInfo(
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
  final Widget body;

  //Na definição do parâmetro {@required this.body}, as chaves indicam que o
  //parâmetro é nominal (named parameter) e a anotação @required indica que o
  //parâmetro é obrigatório.
  DsiScaffold({@required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: getSize(context).height,
            child: this.body,
          ),
        ),
      ),
    );
  }
}
