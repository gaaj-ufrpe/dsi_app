import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

Map<WordPair, bool> wordPairs = Map<WordPair, bool>();

void main() {
  initWordPairs();
  runApp(DSIApp());
}

String capitalize(String s) {
  return '${s[0].toUpperCase()}${s.substring(1)}';
}

void initWordPairs() {
  var generatedWordPairs = generateWordPairs().take(20);
  for (WordPair wordPair in generatedWordPairs) {
    var first = capitalize(wordPair.first);
    var second = capitalize(wordPair.second);
    WordPair newWordPair = WordPair(first, second);
    wordPairs.putIfAbsent(newWordPair, () => null);
  }
}

///App baseado no tutorial do Flutter disponível em:
///https://codelabs.developers.google.com/codelabs/first-flutter-app-pt1
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

class HomePage extends StatefulWidget {
  static const routeName = '/';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  List<Widget> _pages = [
    WordPairListPage(null),
    WordPairListPage(true),
    WordPairListPage(false)
  ];

  void _changePage(int value) {
    setState(() {
      pageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App de Listagem - DSI/BSI/UFRPE'),
      ),
      body: _pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _changePage,
        currentIndex: pageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up_outlined),
            label: 'Liked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_down_outlined),
            label: 'Disliked',
          ),
        ],
      ),
    );
  }
}

class WordPairListPage extends StatefulWidget {
  static const routeName = '/wordpair/list';
  final bool _filter;
  WordPairListPage(this._filter);

  @override
  _WordPairListPageState createState() => _WordPairListPageState();
}

///Esta classe é o estado da classe que lista os pares de palavra
class _WordPairListPageState extends State<WordPairListPage> {
  final _icons = {
    null: Icon(Icons.thumbs_up_down_outlined),
    true: Icon(Icons.thumb_up, color: Colors.blue),
    false: Icon(Icons.thumb_down, color: Colors.red),
  };

  int compareWordPairs(WordPair a, WordPair b) {
    int result = a.first.compareTo(b.first);
    if (result == 0) {
      result = a.second.compareTo(b.second);
    }
    return result;
  }

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

  _toggle(WordPair wordPair) {
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

  String asString(WordPair wordPair) {
    return '${wordPair.first} ${wordPair.second}';
  }

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
            onPressed: () => _salvar(context),
          ),
        ],
      ),
    );
  }

  void _salvar(BuildContext context) {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      _formKey.currentState.save();
      updateWordPair();
    });
    Navigator.popAndPushNamed(context, HomePage.routeName);
  }

  void updateWordPair() {
    WordPair newWordPair = WordPair(_newFirst, _newSecond);
    bool value = wordPairs.remove(_wordPair);
    wordPairs.putIfAbsent(newWordPair, () => value);
  }
}
