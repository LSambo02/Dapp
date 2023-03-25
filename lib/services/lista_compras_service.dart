import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:despensa/models/ListaCompras.dart';
import 'package:despensa/utils/constantes.dart';
import 'package:flutter/material.dart';

import '../utils/GetIt.dart';
import 'familia_service.dart';

class ListaComprasService with ChangeNotifier {
  CollectionReference familias =
      FirebaseFirestore.instance.collection(familias_colecao);
  CollectionReference listasCompras =
      FirebaseFirestore.instance.collection(listaCompras_colecao);

  //funcao lambda pra permitir acesso a coleção de outras classes
  familiasCollection() => familias;

  Future<String> addListaCompras(ListaCompras listaCompras) {
    log('lista_compras_service.dart:::: ${listaCompras.toJson()}');

    //adicionar o objecto em forma de json para a coleção de minions
    return familias
        .doc(getIt<FamiliaService>().familia.id)
        .collection(listaCompras_colecao)
        .add(listaCompras.toJson())
        .then((value) => "ListaCompra ${listaCompras.nomeLista} adicionada");
    // .catchError((error) =>
    //     "Parece que teve problemas ao salvar a lista de compras\n $error");
  }

  Future deleteListaCompra(String nome, String id) {
    return familias
        .doc(getIt<FamiliaService>().familia.id)
        .collection(listaCompras_colecao)
        .doc(id)
        .delete()
        .then((value) => "A lista $nome foi removida")
        .catchError(
            (error) => "Oops, parece que não deu pra remover:\n $error");
  }
}
