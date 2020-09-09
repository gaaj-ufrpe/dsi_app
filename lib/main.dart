import 'dart:convert';

import 'package:dsi_app/aluno.dart';
import 'package:dsi_app/constants.dart';
import 'package:dsi_app/home.dart';
import 'package:dsi_app/login.dart';
import 'package:dsi_app/pessoa.dart';
import 'package:dsi_app/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DSIApp());
}

class DSIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _initDb(context);
    return MaterialApp(
      title: Constants.appName,
      theme: _buildThemeData(),
      initialRoute: '/',
      routes: _buildRoutes(context),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: Colors.green,
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 22.0, fontStyle: FontStyle.italic),
        caption: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
        bodyText1: TextStyle(fontSize: 18.0),
        bodyText2: TextStyle(fontSize: 16.0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: Constants.defaultBorderRadius,
        ),
        contentPadding: Constants.insetsMedium,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.green,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: Constants.defaultBorderRadius,
        ),
      ),
    );
  }

  _buildRoutes(context) {
    return {
      '/': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
      '/home': (context) => HomePage(),
      '/list_pessoa': (context) => ListPessoaPage(),
      '/maintain_pessoa': (context) => MaintainPessoaPage(),
      '/list_aluno': (context) => ListAlunoPage(),
      '/maintain_aluno': (context) => MaintainAlunoPage(),
    };
  }
}

void _initDb(context) {
  //TIP Ao invés de criar o aluno manualmente, passamos a criar a partir de um
  //arquivo que armazena todos os alunos no formato JSON.
  //Este arquivo é declarado como um asset no pubspec.yaml.
  //
  //A leitura do arquivo do bundle retorna um objeto do tipo "Future". Este tipo
  //de objeto é 'assíncrono' ou seja, o aplicativo continua sendo usado enquanto
  //ele termina o seu processamento. Isto é necessário para ações 'pesadas' como
  //a leitura de um arquivo, ou a chamada web. Caso isso não fosse feito, o
  //aplicativo (e o celular) ficariam travados até o término do processamento.
  //Assim, deve-se implementar a funcionalidade que se deseja fazer ao término
  //do processamento, no método 'then'. No nosso caso, o salvamento dos dados.
  //
  //Observe ainda que não está mais sendo usado o 'for'. Agora já estamos
  //usando o método 'forEach' das listas, que chama uma função para cada
  //elemento da lista.
  Future<String> data = DefaultAssetBundle.of(context).loadString('db.json');
  data.then((value) => _processData(value));
}

_processData(jsonString) {
  Map<String, dynamic> jsonMaps = jsonDecode(jsonString);
  jsonMaps['alunos']
      .map<Aluno>((json) => Aluno.fromJson(json))
      .toList()
      .forEach((aluno) => alunoController.save(aluno));
}
