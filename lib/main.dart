import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

Map<WordPair, bool> wordPairs;

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
    );
  }
}

void main() {
  final generatedWordPairs = generateWordPairs().take(20);
  wordPairs =
      Map.fromIterable(generatedWordPairs, key: (e) => e, value: (e) => null);
  runApp(DSIApp());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  List<Widget> _pages = [
    RandomWordsListPage(null),
    RandomWordsListPage(true),
    RandomWordsListPage(false)
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

class RandomWordsListPage extends StatefulWidget {
  final bool filter;
  RandomWordsListPage(this.filter);

  @override
  _RandomWordsListPageState createState() => _RandomWordsListPageState();
}

class _RandomWordsListPageState extends State<RandomWordsListPage> {
  final _icons = {
    null: Icon(Icons.thumbs_up_down_outlined),
    true: Icon(Icons.thumb_up, color: Colors.blue),
    false: Icon(Icons.thumb_down, color: Colors.red),
  };

  Iterable<WordPair> get items {
    if (widget.filter == null) {
      return wordPairs.keys;
    } else {
      return wordPairs.entries
          .where((element) => element.value == widget.filter)
          .map((e) => e.key);
    }
  }

  _toggle(WordPair wordPair) {
    bool like = wordPairs[wordPair];
    if (widget.filter != null) {
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

  String capitalize(String s) {
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }

  String asString(WordPair wordPair) {
    return '${capitalize(wordPair.first)} '
        '${capitalize(wordPair.second)}';
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
          return _buildRow(index + 1, items.elementAt(index));
        });
  }

  Widget _buildRow(int index, WordPair wordPair) {
    return ListTile(
      title: Text('$index. ${asString(wordPair)}'),
      trailing: _icons[wordPairs[wordPair]],
      onTap: () => _toggle(wordPair),
    );
  }
}
