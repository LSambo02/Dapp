import 'package:flutter/cupertino.dart';

class ListaCompras with ChangeNotifier {
  String? _id;
  String? _nomeLista;
  List? _lista;

  ListaCompras.empty();

  String? get id => _id;

  String? get nomeLista => _nomeLista;

  setNomeLista(String? value) {
    _nomeLista = value;
    notifyListeners();
  }

  List? get lista => _lista;

  setLista(List? value) {
    _lista = value;
    notifyListeners();
  }

  ListaCompras.fromJson(Map<String, dynamic> json) {
    this._id = json["id"];
    this._nomeLista = json["nomeLista"];
    this._lista = json["lista"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();

    data["nomeLista"] = this._nomeLista;
    data["lista"] = this._lista;

    return data;
  }
}
