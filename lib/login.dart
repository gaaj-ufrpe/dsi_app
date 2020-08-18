import 'package:dsi_app/constants.dart';
import 'package:dsi_app/infra.dart';
import 'package:dsi_app/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
          LoginForm(),
          Spacer(),
          Padding(
            padding: Constants.paddingMedium,
            child: Text(
              'App desenvolvido por Gabriel Alves para a disciplina de'
              ' Desenvolvimento de Sistemas de Informação do BSI/UFRPE.',
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  void _forgotPassword() {
    DsiDialog.showInfo(
      context: context,
      title: 'Warning',
      message: '''Falta implementar esta função.\n'''
          '''Agora é com vocês!''',
    );
  }

  void _login() {
    if (!_formKey.currentState.validate()) return;

    DsiDialog.showInfo(
        context: context, message: 'Seu login foi efetuado com sucesso.');
  }

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
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
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text('Esqueceu a senha?'),
                padding: Constants.paddingSmall,
                onPressed: _forgotPassword,
              ),
            ),
            Constants.spaceMediumHeight,
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Login'),
                onPressed: _login,
              ),
            ),
            FlatButton(
              child: Text('Cadastre-se'),
              padding: Constants.paddingSmall,
              onPressed: _register,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFlatButton(BuildContext context, String text, var onPressed) {
    return SizedBox.expand(
      child: FlatButton(
        color: Theme.of(context).buttonColor,
        child: Text(text),
        onPressed: _login,
      ),
    );
  }
}
