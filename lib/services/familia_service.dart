import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:despensa/models/Familia.dart';
import 'package:despensa/models/User.dart';
import 'package:despensa/utils/GetIt.dart';
import 'package:despensa/utils/constantes.dart';
import 'package:despensa/utils/sharedPreferences.dart';
import 'package:flutter/cupertino.dart';

import 'auth_service.dart';

class FamiliaService with ChangeNotifier {
  //instanciar a coleção
  CollectionReference familias =
      FirebaseFirestore.instance.collection(familias_colecao);
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  // FamiliaService authService = FamiliaService();

  String _familiaId;

  //funcao lambda pra permitir acesso a coleção de outras classes
  familiasCollection() => familias;

  Future<String> addFamily(Familia familia) {
    //adicionar o objecto em forma de json para a coleção de minions
    return familias.add(familia.toJson()).then((value) {
      _familiaId = value.id;
      addFamiliaToUser(_familiaId);
      return "Família ${familia.nome} adicionada";
    }).catchError(
        (error) => "Parece que teve problemas com a Família\n $error");
  }

  Future<QuerySnapshot> queryCollection(queryString) async {
    //retorna o snapshot equivalente aos objectos json onde
    // o nome é igual ao passado com o argumento
    return await familias.where('nome', isEqualTo: queryString).get();
  }

  Future<String> createUser(userId) {
    users.doc(getIt<AuthService>().userId).get().then((user) {
      if (!user.exists) {
        return users
            .doc(getIt<AuthService>().userId)
            .set(Utilizador().toJson())
            .then((value) {
          notifyListeners();
          return "Utilizador criado";
        }).catchError(
                (error) => "Parece que teve problemas com o registo\n $error");
      } else {
        return users.doc(getIt<AuthService>().userId).get().then((value) {
          print(value.id);
          return value.id;
        });
      }
    });
    // if (users.doc() == null) {
    //
    // }
  }

  Future<String> getFamilyName(String familyId) async {
    return await familias.doc(familyId).get().then(
        (DocumentSnapshot documentSnapshot) =>
            documentSnapshot.get('nome').toString());
  }

  Future<String> getFamilyIdFromName(String familyName) async {
    return await queryCollection(familyName).then((QuerySnapshot matches) {
      return matches.docs.first.id;
    });
  }

  Future<Map<String, dynamic>> getUserFamilies() async {
    Map<String, dynamic> families = {};

    return users
        .doc(getIt<AuthService>().userId)
        .get()
        .then((DocumentSnapshot user) {
      List familias = user.get('familias');
      print(familias);
      for (String id in familias) {
        return getFamilyName(id).then((value) {
          families[value] = id;
          return families;
        });
      }

      // return families;
    });
  }

  Future<String> addFamiliaToUser(String familiaId) {
    users.doc(getIt<AuthService>().userId).get().then((DocumentSnapshot user) {
      List<String> familias =
          user.get("familias") != null ? user.get("familias") : [];
      familias.add(familiaId);
      return users
          .doc(getIt<AuthService>().userId)
          .update({"familias": familias}).then((value) {
        _familiaId = familiaId;
        notifyListeners();
        getIt<UserState>().saveFamilyId(_familiaId);
        return "Faz agora parte da Família, Parabéns";
      }).catchError(
              (error) => "Parece que teve problemas com o registo\n $error");
    });
  }

  Future<String> checkUser(String familiaName) {
    return users
        .doc(getIt<AuthService>().userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      List<dynamic> familiasList = documentSnapshot.get("familias");
      return queryCollection(familiaName).then((QuerySnapshot querySnapshot) {
        print(familiaName);
        if (querySnapshot.docs.isNotEmpty) {
          String familyId = querySnapshot.docs.first.id;
          return (familiasList.contains(familyId)) ? familyId : null;
        } else {
          return null;
        }
      });
    });
  }

  Future updateFamilia(nome, novoNome) {
    //com base na coleção pegamos todos os dados que nela existem, que retorna
    //QuerySnapshot e usando o mesmo para iterar pelos documentos dentro dele
    return familias.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //verificar se o dcumento tem como atributo nome igual ao pretendido alterar
        if (doc['nome'] == nome) {
          familias
              .doc(doc.id) //pegar o id do documento que se pretende actualizar
              .update({'nome': novoNome})
              .then((value) => "Mudou nome da familia para $novoNome")
              .catchError((error) =>
                  "Oops, parece que não deu pra actualizar:\n $error");
        }
      });
    });
  }

  // Future<String> addShelve(familia_name, userId) async {
  //   QuerySnapshot familia =
  //       await familias.where('nome', isEqualTo: familia_name).get();
  //   String familiaId = familia.docs[0].reference.id;
  //   return familias_users
  //       .add({"familiaId": familiaId, "userId": userId})
  //       .then((value) => "Foi adicionado a $familia_name")
  //       .catchError((error) =>
  //           "Parece que teve problemas com o último Produto:\n $error");
  // }
  String setFamiliaId(String value) {
    _familiaId = value;
    notifyListeners();
  }

  String get familiaId => _familiaId;
}
