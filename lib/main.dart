import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(DSIApp());

class DSIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSI App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black, fontSize: 18.0),
          subtitle2: TextStyle(
            color: Colors.red,
            fontSize: 24.0,
            fontFamily: 'Xilo',
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      home: DSIPage(title: 'My First App - DSI/BSI/UFRPE'),
    );
  }
}

class DSIPage extends StatefulWidget {
  final String title;

  DSIPage({Key key, this.title}) : super(key: key);

  @override
  _DSIPageState createState() => _DSIPageState();
}

class _DSIPageState extends State<DSIPage> {
  final _warnings = [
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

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  String get _countText => 'Você clicou $_counter vezes no botão.';

  String get _warningText {
    String result = '';
    if (_counter > 5) {
      var idx = Random().nextInt(_warnings.length);
      result = _warnings[idx];
    }
    return result;
  }

  String get _imageName {
    //abra o arquivo 'pubspec.yaml' e veja as entradas na seção 'assets'.
    //para incluir novas imagens, basta incluir novas entradas nesta seção.
    String result;
    if (_counter == 0) {
      result = '';
    } else if (_counter > 5) {
      result = 'images/jadeu.png';
    } else if (_counter > 2) {
      result = 'images/thug2.gif';
    } else {
      result = 'images/thug1.jpg';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(widget.title),
            Spacer(),
            Image(image: AssetImage('images/logo/bsi-white.png'), height: 32),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              DSIMainBodyWidget(_countText, _warningText, _imageName),
              Spacer(),
              TextButton(
                onPressed: _resetCounter,
                child: Text('Reset'),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DSIMainBodyWidget extends StatelessWidget {
  final String _countText;
  final String _warningText;
  final String _image;
  DSIMainBodyWidget(this._countText, this._warningText, this._image);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(_countText),
        if (_warningText.isNotEmpty)
          Text(
            _warningText,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        if (_image.isNotEmpty) SizedBox(height: 8.0),
        if (_image.isNotEmpty)
          Image(
            image: AssetImage(_image),
            height: 240,
          ),
      ],
    );
  }
}
