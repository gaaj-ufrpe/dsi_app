import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

///Mapa que armazena o par de palavras ([WordPair]) na chave e um [bool] no
///valor, indicando se o usuário curtiu ([true]), não curtiu ([false]) ou ficou
///indiferente ([null]) ao par de palavras.
Map<WordPair, bool> wordPairs;

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

///Classe principal que representa o App.
class DSIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Listagem - DSI/BSI/UFRPE',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      initialRoute: HomePage.routeName,
      routes: _buildRoutes(context),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes(BuildContext context) {
    return {
      WordPairUpdatePage.routeName: (context) => WordPairUpdatePage(),
    };
  }
}

///Página inicial que apresenta o [BottomNavigationBar], onde cada
///[BottomNavigationBarItem] é uma página do tipo [WordPairListPage].
class HomePage extends StatefulWidget {
  static const routeName = '/';
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
            label: 'Home',
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
  ///Nome da rota que leva a esta página.
  static const routeName = '/wordpair/list';

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

  ///Compara dois pares de palavras.
  ///Retorna:
  ///-1 se [a] for menor que [b];
  ///0 se [a] for igual [b];
  ///1 se [a] for maior que [b];
  int compareWordPairs(WordPair a, WordPair b) {
    int result = a.first.compareTo(b.first);
    if (result == 0) {
      result = a.second.compareTo(b.second);
    }
    return result;
  }

  ///Método getter para retornar os itens.
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
    result.sort(compareWordPairs);
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
          return _buildRow(context, index + 1, items.elementAt(index));
        });
  }

  ///Constroi uma linha da listagem a partir do par de palavras e do índice.
  Widget _buildRow(BuildContext context, int index, WordPair wordPair) {
    return ListTile(
      title: Text('$index. ${asString(wordPair)}'),
      trailing: TextButton(
        onPressed: () => _toggle(wordPair),
        child: _icons[wordPairs[wordPair]],
      ),
      onTap: () => Navigator.pushNamed(context, WordPairUpdatePage.routeName,
          arguments: wordPair),
    );
  }
}

class WordPairUpdatePage extends StatefulWidget {
  static const routeName = '/wordpair/update';

  WordPairUpdatePage();

  @override
  _WordPairUpdatePageState createState() => _WordPairUpdatePageState();
}

///Esta classe é o estado da classe que atualiza os pares de palavras.
class _WordPairUpdatePageState extends State<WordPairUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  WordPair _wordPair;
  String _newFirst;
  String _newSecond;

  @override
  Widget build(BuildContext context) {
    _wordPair = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('App de Listagem - DSI/BSI/UFRPE'),
      ),
      body: _buildForm(context),
    );
  }
}
