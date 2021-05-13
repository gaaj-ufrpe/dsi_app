import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsi_app/model/word_pair_model.dart';

///Controlador do módulo de pares de palavras.
class DSIWordPairController {
  CollectionReference<Map<String, dynamic>> _wordPairs;

  ///Construtor da classe.
  DSIWordPairController() {
    _initWordPairs();
  }

  ///Inicializa a lista com os pares de palavras.
  void _initWordPairs() {
    _wordPairs = FirebaseFirestore.instance.collection('wordpairs');
  }

  ///Cria um par de palavras a partir do snapshot do documento.
  DSIWordPair _createWordPair(DocumentSnapshot<Map<String, dynamic>> e) {
    DSIWordPair result = DSIWordPair.fromJson(e.data());
    result.id = e.id;
    return result;
  }

  ///Retorna uma lista com todos os pares de palavras cadastrados.
  ///Esta lista não pode ser modificada. Ou seja, não é possível inserir ou
  ///remover elementos diretamente na lista.
  Future<Iterable<DSIWordPair>> getAll() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _wordPairs.get();
    return snapshot.docs.map((e) => _createWordPair(e));
  }

  ///Retorna o par de palavras pelo [id], ou [null] caso não exista nenhum par
  ///com o [id] informado.
  Future<DSIWordPair> getById(String id) async {
    if (id == null) return null;

    DocumentSnapshot doc = await _wordPairs.doc(id).get();
    return _createWordPair(doc);
  }

  ///Retorna uma lista de pares de palavras, onde os elementos da lista respeitam
  ///a condição representada pela função passada como parâmetro. Caso a função
  ///passada seja [null], retorna todos os elementos.
  Future<Iterable<DSIWordPair>> getByFilter(
      bool test(DSIWordPair element)) async {
    Iterable<DSIWordPair> result = await getAll();
    if (test != null) {
      result = result.where(test).toList();
    }
    return List.unmodifiable(result);
  }

  ///Atualiza ou insere o par de palavras.
  ///A atualização ocorre caso o par de palavras possua um [id] setado.
  Future save(DSIWordPair wordPair) async {
    if (wordPair.id == null) {
      return _wordPairs.add(wordPair.toJson());
    } else {
      return _wordPairs.doc(wordPair.id).update(wordPair.toJson());
    }
  }

  ///Remove o par de palavras.
  Future delete(DSIWordPair wordPair) {
    return _wordPairs.doc(wordPair.id).delete();
  }
}
