import 'package:dsi_app/constants.dart';
import 'package:dsi_app/infra.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      body: Column(
        children: <Widget>[
          Spacer(),
          Image(
            image: Images.bsiLogo,
            height: 100,
          ),
          Constants.spaceSmallHeight,
          RegisterForm(),
          Spacer(),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  void _register() {
    if (!_formKey.currentState.validate()) return;

    dsiDialog.showInfo(
      context: context,
      message: 'Seu cadastro foi realizado com sucesso.',
      buttonPressed: () => dsiHelper..back(context)..back(context),
    );

    //A linha acima é equivalente a executar as duas linhas abaixo:
    //Navigator.of(context).pop();
    //Navigator.of(context).pop();
    //
    //Para maiores informações, leia sobre 'cascade notation' no Dart.
    //https://dart.dev/guides/language/language-tour
  }

  void _cancel() {
    dsiHelper.back(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: Constants.paddingMedium,
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'E-mail*'),
              validator: (String value) {
                return value.isEmpty ? 'Email inválido.' : null;
              },
            ),
            Constants.spaceSmallHeight,
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Login*'),
              validator: (String value) {
                return value.isEmpty ? 'Login inválido.' : null;
              },
            ),
            Constants.spaceSmallHeight,
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha*'),
              validator: (String value) {
                return value.isEmpty ? 'Senha inválida.' : null;
              },
            ),
            Constants.spaceSmallHeight,
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Confirmação de Senha*'),
              validator: (String value) {
                return value.isEmpty
                    ? 'As senhas digitadas não são iguais.'
                    : null;
              },
            ),
            Constants.spaceMediumHeight,
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Salvar'),
                onPressed: _register,
              ),
            ),
            FlatButton(
              child: Text('Cancelar'),
              padding: Constants.paddingSmall,
              onPressed: _cancel,
            ),
          ],
        ),
      ),
    );
  }
}
