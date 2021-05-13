import 'dart:async';

import 'package:dsi_app/view/word_pair_view.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

///TPC-2 (branch_wordPairs1):
///Este app foi baseado no tutorial do Flutter disponível em:
///https://codelabs.developers.google.com/codelabs/first-flutter-app-pt1
///
/// Ele foi adaptado para utilizar o [BottomNavigationBar] exibindo listagens de
/// palavras que o usuário gosta e desgosta. Para armazenar se o usuário gostou,
/// desgostou, ou simplesmente não fez nada com a palavra, este app utiliza um
/// [Map] denominado [wordPairs]. Este mapa, equivalente ao dicionário do Python,
/// armazena o par de palavras como chave e um valor do tipo [bool], indicando
/// se o usuário gostou ou desgostou da palavra. Caso seja null, indica que o
/// usuário não gostou nem desgostou da palavra.
///
/// Vale frisar, que este mapa foi criado usando Generics. Assim, caso o
/// programador tente colocar uma chave diferente do tipo [WordPair] ou um valor
/// que não seja do tipo [bool], ocorrerá um erro de compilação.
/// Para maiores informações, acesse:
/// https://dart.dev/guides/language/language-tour#generics
///
/// Este código também inclui um getter para os itens deste mapa (vide [items]).
/// Para maiores informações acesse:
/// https://dart.dev/guides/language/language-tour#getters-and-setters
///
///TPC-3 (branch_wordPairs2):
/// Este app foi ajustado para usar uma classe própria ([DSIWordPair]), ao invés
/// de usar o [WordPair] diretamente. Assim, novos atributos podem ser
/// adicionados na classe. Assim, ao invés de utilizar o Map para armazenar
/// a informação da curtida, esta informação fica em um atributo da própria
/// classe.
///
/// Esta classe sobrescreve dois métodos importantes: o [DSIWordPair#toString]
/// e o [DSIWordPair#compareTo]. O primeiro converte um objeto desta classe em
/// uma string (evitando a necessidade da função [asString] criada no tópico
/// anterior. Já o segundo, compara um objeto da classe com outro, permitindo
/// o conceito de ordenamento, utilizado no método [List#sort].
///
/// Esta atualização também ajusta a linha da listagem para diferenciar o botão
/// de curtida e a linha.
///
///TPC-3 (branch_wordPairs3):
/// Esta atualização inclui a parte de rotas, que permite navegar entre as telas
/// em um App Flutter. Além disso, é criada a tela de atualização do par de palavras.
/// Acesse: https://flutter.dev/docs/cookbook/navigation/named-routes
///
///TPC-4 (branch_wordPairs4):
/// Esta atualização ajusta o código para utilizar os padrões
/// MVC (Model-View-Controller) e Singleton.
/// Acesse:
/// https://pt.wikipedia.org/wiki/MVC
/// https://pt.wikipedia.org/wiki/Singleton
///
///TPC-5 (branch_wordPairs5):
/// Persistência dos dados com o Firebase.
/// Veja os ajustes feitos em: pubspec.yaml,
/// Acesse:
/// https://firebase.flutter.dev/docs/overview/
/// https://firebase.flutter.dev/docs/installation/android/
///
/// ATENÇÃO:
/// -Configure o plugin no pubspec.yaml
/// -Adicione o android/app/google-services.json no projeto (gerar no Firebase Console)
/// -atualize o android/build.gradle com as informações dos serviços do google
/// -atualize o android/app/build.gradle
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DSIApp());
}

///Classe principal que representa o App.
///O uso do widget do tipo Stateful evita a reinicialização do Firebase
///cada vez que o App é reconstruído.
class DSIApp extends StatefulWidget {
  ///Cria o estado do app.
  @override
  _DSIAppState createState() => _DSIAppState();
}

///O estado do app.
class _DSIAppState extends State<DSIApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  ///Constrói o App a partir do FutureBuilder, após o carregamento do Firebase.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildError(context);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return _buildApp(context);
        }

        return _buildLoading(context);
      },
    );
  }

  ///Constroi o componente que apresenta o erro no carregamento do Firebase.
  Widget _buildError(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Text(
          'Erro ao carregar os dados do App.\n'
          'Tente novamente mais tarde.',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  ///Constrói o componente de load.
  Widget _buildLoading(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              'carregando...',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Constrói o App e suas configurações.
  Widget _buildApp(context) {
    return MaterialApp(
      title: 'DSI App (BSI UFRPE)',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      initialRoute: HomePage.routeName,
      routes: _buildRoutes(context),
    );
  }

  ///Método utilizado para configurar as rotas.
  Map<String, WidgetBuilder> _buildRoutes(BuildContext context) {
    return {
      WordPairUpdatePage.routeName: (context) => WordPairUpdatePage(),
    };
  }
}
