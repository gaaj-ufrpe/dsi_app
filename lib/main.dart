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
///TPC-3 (branch_wordPairs3):
/// Esta atualização inclui a parte de rotas, que permite navegar entre as telas
/// em um App Flutter. Além disso, é criada a tela de atualização do par de palavras.
/// Acesse: https://flutter.dev/docs/cookbook/navigation/named-routes
void main() {
  initWordPairs();
  runApp(DSIApp());
}

///Inicializa a lista com os pares de palavras.
void initWordPairs() {
  wordPairs = <DSIWordPair>[];
  for (var i = 0; i < 20; i++) {
    wordPairs.add(DSIWordPair());
  }
  wordPairs.sort();
}

///Lista de pares de palavras ([DSIWordPair]) .
List<DSIWordPair> wordPairs;

/// Função que deixa uma string com a primeira letra maiúscula.
String capitalize(String s) {
  return '${s[0].toUpperCase()}${s.substring(1)}';
}

///Esta classe é uma implementação própria do [WordPair], incluindo outros
///atributos e métodos necessários para o App.
class DSIWordPair extends Comparable<DSIWordPair> {
  String first, second;
  bool favourite;
  DSIWordPair() {
    WordPair wordPair = WordPair.random();
    this.first = capitalize(wordPair.first);
    this.second = capitalize(wordPair.second);
  }

  @override
  String toString() {
    return '${this.first} ${this.second}';
  }

  ///Compara dois pares de palavras.
  ///Retorna:
  ///-1 se [a] for menor que [b];
  ///0 se [a] for igual [b];
  ///1 se [a] for maior que [b];
  @override
  int compareTo(DSIWordPair that) {
    int result = this.first.compareTo(that.first);
    if (result == 0) {
      result = this.second.compareTo(that.second);
    }
    return result;
  }
}

///Classe principal que representa o App.
class DSIApp extends StatelessWidget {
  ///Constrói o App e suas configurações.
  @override
  Widget build(BuildContext context) {
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
        title: Text('DSI App (BSI UFRPE)'),
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

  ///Método getter para retornar os itens. Os itens são ordenados utilizando a
  ///ordenação definida na classe [DSIWordPair].
  ///
  ///Dependendo do que está setado no atributo [widget._filter], este método
  ///retorna todas as palavras, as palavras curtidas ou as palavras não curtidas.
  ///Veja:
  /// https://dart.dev/guides/language/language-tour#getters-and-setters
  Iterable<DSIWordPair> get items {
    List<DSIWordPair> result;
    if (widget._filter == null) {
      result = wordPairs;
    } else {
      result = wordPairs
          .where((element) => element.favourite == widget._filter)
          .toList();
    }
    return result;
  }

  ///Altera o estado de curtida da palavra.
  _toggleFavourite(DSIWordPair wordPair) {
    bool like = wordPair.favourite;
    if (widget._filter != null) {
      wordPair.favourite = null;
    } else if (like == null) {
      wordPair.favourite = true;
    } else if (like == true) {
      wordPair.favourite = false;
    } else {
      wordPair.favourite = null;
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
  Widget _buildRow(BuildContext context, int index, DSIWordPair wordPair) {
    return ListTile(
      title: Text('$index. ${wordPair}'),
      trailing: TextButton(
        onPressed: () => _toggleFavourite(wordPair),
        child: _icons[wordPair.favourite],
      ),
      onTap: () => _updateWordPair(context, wordPair),
    );
  }

  ///Exibe a tela de atualização do par de palavras.
  _updateWordPair(BuildContext context, DSIWordPair wordPair) {
    Navigator.pushNamed(context, WordPairUpdatePage.routeName,
        arguments: wordPair);
  }
}

///Página que apresenta a tela de atualização do par de palavras.
class WordPairUpdatePage extends StatefulWidget {
  static const routeName = '/wordpair/update';

  WordPairUpdatePage();

  @override
  _WordPairUpdatePageState createState() => _WordPairUpdatePageState();
}

///Esta classe é o estado da classe que atualiza os pares de palavras.
class _WordPairUpdatePageState extends State<WordPairUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  DSIWordPair _wordPair;
  String _newFirst;
  String _newSecond;

  ///Método responsável por criar a tela de atualização do par de palavras.
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

  ///Método utilizado para criar o corpo da tela de atualização do par de palavras.
  _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 16.0,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Primeira*'),
            validator: (String value) {
              return value.isEmpty ? 'Palavra inválida.' : null;
            },
            onSaved: (newValue) => _newFirst = newValue,
            initialValue: _wordPair.first,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Segunda*'),
            validator: (String value) {
              return value.isEmpty ? 'Palavra inválida.' : null;
            },
            onSaved: (newValue) => _newSecond = newValue,
            initialValue: _wordPair.second,
          ),
          SizedBox(
            width: double.infinity,
          ),
          ElevatedButton(
            child: Text('Salvar'),
            onPressed: () => _save(context),
          ),
        ],
      ),
    );
  }

  ///Método que valida o formulário e salva os dados no par de palavras.
  void _save(BuildContext context) {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      _formKey.currentState.save();
      _updateWordPair();
    });
    Navigator.popAndPushNamed(context, HomePage.routeName);
  }

  ///Recupera os dados que os campos de texto atualizaram nos atributos da classe
  ///e atualiza o par de palavras.
  void _updateWordPair() {
    _wordPair.first = _newFirst;
    _wordPair.second = _newSecond;
  }
}
