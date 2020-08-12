import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSI App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'DSI App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _phrases = [
    'JÁ DEU BENÇA!',
    'VAI QUEBRAR O CELULAR!',
    'PARA VÉI!',
    'QUE DEDO NERVOSO!',
    'PRA QUE ISSO?!',
  ];
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String _getRandomPhrase() {
    var idx = Random().nextInt(_phrases.length);
    return _phrases[idx];
  }

  String _getText() {
    String result = 'Você clicou $_counter vezes no botão.';
    if (_counter > 5) {
      result += '\n${_getRandomPhrase()}';
    }
    return result;
  }

  String _getImageName() {
    //abra o arquivo 'pubspec.yaml' e veja as entradas na seção 'assets'.
    //para incluir novas imagens, basta incluir novas entradas nesta seção.
    String result = '';
    if (_counter > 5) {
      result = 'images/jadeu.png';
    } else if (_counter > 2) {
      result = 'images/thug2.gif';
    } else if (_counter > 0) {
      result = 'images/thug1.jpg';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: MyMessageWidget(_getText(), _getImageName())),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyMessageWidget extends StatelessWidget {
  String _text = '';
  String _image = '';
  MyMessageWidget(this._text, this._image);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _text,
            ),
          ),
          Image(
            image: AssetImage(_image),
            height: 180,
          ),
        ]);
  }
}
