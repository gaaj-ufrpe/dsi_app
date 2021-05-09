import 'package:dsi_app/model/word_pair_model.dart';

///Armazena o próximo id.
int _nextWordPairId = 1;

///Lista de pares de palavras ([DSIWordPair]).
List<DSIWordPair> _wordPairs;

///Controlador do módulo de pares de palavras.
class DSIWordPairController {
  ///Construtor da classe.
  DSIWordPairController() {
    _initWordPairs();
  }

  ///Inicializa a lista com os pares de palavras.
  void _initWordPairs() {
    if (_wordPairs != null) return;

    _wordPairs = <DSIWordPair>[];
    for (var i = 0; i < 20; i++) {
      DSIWordPair wordPair = DSIWordPair();
      wordPair.id = _nextWordPairId++;
      _wordPairs.add(wordPair);
    }
    _wordPairs.sort();
  }

  ///Retorna uma lista com todos os pares de palavras cadastrados.
  ///Esta lista não pode ser modificada. Ou seja, não é possível inserir ou
  ///remover elementos diretamente na lista.
  List<DSIWordPair> getAll() {
    return List.unmodifiable(_wordPairs);
  }

  ///Retorna o par de palavras pelo [id], ou [null] caso não exista nenhum par
  ///com o [id] informado.
  DSIWordPair getById(int id) {
    if (id == null) return null;

    for (var wp in _wordPairs) {
      if (wp.id == id) return wp;
    }
    return null;
  }

  ///Retorna uma lista de pares de palavras, onde os elementos da lista respeitam
  ///a condição representada pela função passada como parâmetro. Caso a função
  ///passada seja [null], retorna todos os elementos.
  List<DSIWordPair> getByFilter(bool test(DSIWordPair element)) {
    List<DSIWordPair> result = _wordPairs;
    if (test != null) {
      result = _wordPairs.where(test).toList();
    }
    return List.unmodifiable(result);
  }

  ///Atualiza ou insere o par de palavras.
  ///A atualização ocorre caso o par de palavras possua um [id] setado.
  void save(DSIWordPair wordPair) {
    if (wordPair.id == null) {
      wordPair.id = _nextWordPairId++;
    } else {
      DSIWordPair oldWordPair = getById(wordPair.id);
      delete(oldWordPair);
    }
    _wordPairs.add(wordPair);
    _wordPairs.sort();
  }

  ///Remove o par de palavras.
  void delete(DSIWordPair wordPair) {
    _wordPairs.remove(wordPair);
    _wordPairs.sort();
  }
}
