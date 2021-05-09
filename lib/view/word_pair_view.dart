import 'package:dsi_app/controller/word_pair_controller.dart';
import 'package:dsi_app/model/word_pair_model.dart';
import 'package:flutter/material.dart';

///Página inicial que apresenta o [BottomNavigationBar], onde cada
///[BottomNavigationBarItem] é uma página do tipo [WordPairListPage].
class HomePage extends StatefulWidget {
  ///Nome da rota referente à página Home.
  static const routeName = '/';

  ///Cria o estado da página Home.
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
  final DSIWordPairController _controller = DSIWordPairController();
  List<DSIWordPair> _wordPairs;

  ///Map com os ícones utilizados no [BottomNavigationBar].
  final _icons = {
    null: Icon(Icons.thumbs_up_down_outlined),
    true: Icon(Icons.thumb_up, color: Colors.blue),
    false: Icon(Icons.thumb_down, color: Colors.red),
  };

  _WordPairListPageState() {
    _initWordPairs();
  }

  ///Este método é sobrescrito para atualizar a ordem da lista, sempre que a
  ///tela for exibida. A inicialização dos atributos do estado sempre devem
  ///ser feitas no método [initState] do Flutter.
  @override
  void initState() {
    super.initState();
  }

  ///Método utilizado para inicializar o atributo com os pares de palavras do
  ///Widget. Estes pares são recuperados a partir do controlador.
  void _initWordPairs() {
    if (widget._filter == null) {
      print('_initWordPairs: 1');
      _wordPairs = _controller.getAll();
    } else {
      print('_initWordPairs: 2');
      _wordPairs = _controller
          .getByFilter((element) => element.favourite == widget._filter);
    }
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
    _controller.save(wordPair);
    setState(() {});
  }

  ///Constroi a listagem de itens.
  ///Note que é dobrada a quantidade de itens, para que a cada índice par, se
  ///inclua um separador ([Divider]) na listagem.
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _wordPairs.length * 2,
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }
          final int index = i ~/ 2;
          return _buildRow(context, index + 1, _wordPairs.elementAt(index));
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

  ///Construtor da classe
  WordPairUpdatePage();

  ///Cria o estado da página de atualização de palavras.
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
        title: Text('DSI App (BSI UFRPE)'),
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
    Navigator.pop(context, HomePage.routeName);
  }

  ///Recupera os dados que os campos de texto atualizaram nos atributos da classe
  ///e atualiza o par de palavras.
  void _updateWordPair() {
    _wordPair.first = _newFirst;
    _wordPair.second = _newSecond;
  }
}
