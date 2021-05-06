import 'package:english_words/english_words.dart';
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
void main() {
  initWordPairs();
  runApp(DSIApp());
}

///Inicializa o mapa com os pares de palavras.
void initWordPairs() {
  wordPairs = Map<WordPair, bool>();
  final generatedWordPairs = generateWordPairs().take(20);
  for (WordPair wordPair in generatedWordPairs) {
    var first = capitalize(wordPair.first);
    var second = capitalize(wordPair.second);
    var key = WordPair(first, second);
    wordPairs.putIfAbsent(key, () => null);
  }
}

///Mapa que armazena o par de palavras ([WordPair]) na chave e um [bool] no
///valor, indicando se o usuário curtiu ([true]), não curtiu ([false]) ou ficou
///indiferente ([null]) ao par de palavras.
Map<WordPair, bool> wordPairs;

/// Função que deixa uma string com a primeira letra maiúscula.
String capitalize(String s) {
  return '${s[0].toUpperCase()}${s.substring(1)}';
}

/// Função que converte um objeto da classe [WordPair] para uma [String].
String asString(WordPair wordPair) {
  return '${capitalize(wordPair.first)} ${capitalize(wordPair.second)}';
}

///Classe principal que representa o App.
class DSIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSI App (BSI UFRPE)',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

///Página inicial que apresenta o [BottomNavigationBar], onde cada
///[BottomNavigationBarItem] é uma página do tipo [WordPairListPage].
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

///O estado equivalente ao [StatefulWidget] [HomePage].
class _HomePageState extends State<HomePage> {
  ///A página atual em que o [BottomNavigationBar] se encontra.
  int _pageIndex = 0;

  ///As 3 páginas do [HomePage].
  ///A primeira apresenta todas as palavras, a segunda apresenta as palavras que
  ///o usuário gosta e a terceira apresenta as palavras que o usuário não gosta.
  List<Widget> _pages = [
    WordPairListPage(null),
    WordPairListPage(true),
    WordPairListPage(false)
  ];

  ///Método utilizado para alterar a página atual do [HomePage].
  void _changePage(int value) {
    setState(() {
      _pageIndex = value;
    });
  }

  ///Constroi a tela do [HomePage], incluindo um [BottomNavigationBar]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App de Listagem - DSI/BSI/UFRPE'),
      ),
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _changePage,
        currentIndex: _pageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Todas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up_outlined),
            label: 'Curti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_down_outlined),
            label: 'Não Curti',
          ),
        ],
      ),
    );
  }
}

///Página que apresenta a listagem de palavras.
class WordPairListPage extends StatefulWidget {
  ///atributo que determina as palavras que serão exibidas na listagem.
  ///
  ///[null]: todas as palavras.
  ///[true]: palavras que gosta.
  ///[false]: palavras que não gosta.
  final bool _filter;

  ///Construtor da classe
  WordPairListPage(this._filter);

  ///Método responsável por criar o objeto estado.
  @override
  _WordPairListPageState createState() => _WordPairListPageState();
}

///Esta classe é o estado da classe [WordPairListPage].
class _WordPairListPageState extends State<WordPairListPage> {
  ///Map com os ícones utilizados no [BottomNavigationBar].
  final _icons = {
    null: Icon(Icons.thumbs_up_down_outlined),
    true: Icon(Icons.thumb_up, color: Colors.blue),
    false: Icon(Icons.thumb_down, color: Colors.red),
  };

  ///Método getter para retornar os itens.
  ///
  ///Dependendo do que está setado no atributo [widget._filter], este método
  ///retorna todas as palavras, as palavras curtidas ou as palavras não curtidas.
  ///Veja:
  /// https://dart.dev/guides/language/language-tour#getters-and-setters
  Iterable<WordPair> get items {
    List<WordPair> result;
    if (widget._filter == null) {
      result = wordPairs.keys.toList();
    } else {
      result = wordPairs.entries
          .where((element) => element.value == widget._filter)
          .map((e) => e.key)
          .toList();
    }
    return result;
  }

  ///Altera o estado de curtida da palavra.
  _toggleFavourite(WordPair wordPair) {
    bool like = wordPairs[wordPair];
    if (widget._filter != null) {
      wordPairs[wordPair] = null;
    } else if (like == null) {
      wordPairs[wordPair] = true;
    } else if (like == true) {
      wordPairs[wordPair] = false;
    } else {
      wordPairs[wordPair] = null;
    }
    setState(() {});
  }

  ///Constroi a listagem de itens.
  ///Note que é dobrada a quantidade de itens, para que a cada índice par, se
  ///inclua um separador ([Divider]) na listagem.
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length * 2,
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }
          final int index = i ~/ 2;
          return _buildRow(index + 1, items.elementAt(index));
        });
  }

  ///Constroi uma linha da listagem a partir do par de palavras e do índice.
  Widget _buildRow(int index, WordPair wordPair) {
    return ListTile(
      title: Text('$index. ${asString(wordPair)}'),
      trailing: _icons[wordPairs[wordPair]],
      onTap: () => _toggleFavourite(wordPair),
    );
  }
}
