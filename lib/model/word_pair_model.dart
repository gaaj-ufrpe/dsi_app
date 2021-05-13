import 'package:english_words/english_words.dart';

///Esta classe é uma implementação própria do [WordPair], incluindo outros
///atributos e métodos necessários para o App.
class DSIWordPair extends Comparable<DSIWordPair> {
  ///O identificador do objeto.
  String id;

  ///A primeira palavra do par.
  String first;

  ///A segunda palavra do par.
  String second;

  ///Booleano que pode ser [null], indicando se o par de palavras é
  ///favoritado ou não.
  bool favourite;

  ///Construtor da classe
  DSIWordPair() {
    WordPair wordPair = WordPair.random();
    this.first = _capitalize(wordPair.first);
    this.second = _capitalize(wordPair.second);
  }

  /// Método que deixa uma string com a primeira letra maiúscula.
  String _capitalize(String s) {
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }

  ///Este método foi sobrescrito para customizar a conversão de um objeto desta
  ///calsse para String
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
    int result = this.first.toLowerCase().compareTo(that.first.toLowerCase());
    if (result == 0) {
      result = this.second.toLowerCase().compareTo(that.second.toLowerCase());
    }
    return result;
  }

  ///Converte um objeto JSON para um objeto do tipo [DSIWordPair].
  DSIWordPair.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    first = json['first'];
    second = json['second'];
    favourite = json['favourite'];
  }

  ///Converte o objeto atual para um objeto JSON.
  Map<String, dynamic> toJson() => {
        'first': first,
        'second': second,
        'favourite': favourite,
      };
}
