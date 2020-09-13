import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final dsiHelper = _DsiHelper();

class _DsiHelper {
  Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double getScreenHeight(BuildContext context) {
    return getScreenSize(context).height;
  }

  double getScreenWidth(BuildContext context) {
    return getScreenSize(context).width;
  }

  void go(context, routeName, {arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  void back(context) {
    Navigator.pop(context);
  }

  void exit(context) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/', (Route<dynamic> route) => false);
  }

  Object getRouteArgs(context) {
    return ModalRoute.of(context).settings.arguments;
  }

  void showMessage({
    context,
    message = 'Operação realizada com sucesso.',
  }) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void showAlert(
      {context,
      message = 'Operação realizada com sucesso.',
      title = 'Sucesso',
      onPressed}) {
    var dialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('Fechar'),
          onPressed: () {
            if (onPressed == null) {
              Navigator.of(context).pop();
            } else {
              onPressed.call();
            }
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  bool isInsert(path, object) {
    return object.id == null || getJson(path, (json) => Object()) == null;
  }

  bool isOK(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  bool isFail(http.Response response) {
    return !isOK(response);
  }

  var _server = 'my-json-server.typicode.com';

  String _path(String res, [int id]) {
    String result = 'gaaj-ufrpe/dsi_app/${res}';
    if (id != null) result = '$result/$id';
    return result;
  }

  ///TIP a palavra reservada 'await' só pode ser usada dentro de um
  ///método/função sincronizado. Ele indica que esta linha de código irá
  ///esperar até que o objeto embutido no 'Future' esteja disponível.
  ///Neste caso, irá esperar até que o response esteja disponível.
  ///Caso não fosse usado o 'await', o objeto não seria um http.Respose, mas
  ///um Future<http.Response>. Remova a palavra reservada e veja o
  ///comportamento do código.
  ///
  ///Caso a resposta da API REST tenha sido uma lista de mapas json, o
  ///retorno será uma lista de objetos convertidos pela função [fromJson].
  ///Caso a resposta tenha sido apenas um mapa, o retorno será um único
  ///objeto convertido por esta função.
  Future<T> getJson<T>(String res, T fromJson(json),
      [Map<String, String> params]) async {
    var uri = Uri.https(_server, _path(res), params);
    var response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    });
    return _parseResponse(response, fromJson);
  }

  Future<T> putJson<T>(String res, int id,
      T fromJson(Map<String, dynamic> json), Map<String, dynamic> body) async {
    http.Response response = await _insertOrUpdate(res, id, body);
    return _parseResponse(response, fromJson);
  }

  dynamic _parseResponse(http.Response response, fromJson) {
    if (isOK(response)) {
      var jsonResponse = jsonDecode(response.body);
      return fromJson(jsonResponse);
    } else {
      throw Exception('Falha ao carregar os dados.');
    }
  }

  Future<http.Response> _insertOrUpdate(
      String res, int id, Map<String, dynamic> body) async {
    var uri = Uri.https(_server, _path(res, id));
    if (id == null) {
      return http.post(uri, body: jsonEncode(body), headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      });
    } else {
      return http.put(uri, body: jsonEncode(body), headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      });
    }
  }

  Future<bool> deleteJson(String res, int id) async {
    var uri = Uri.https(_server, _path(res, id));
    var response = await http.delete(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    });
    return isOK(response);
  }
}
