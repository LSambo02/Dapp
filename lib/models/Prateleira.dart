import 'package:flutter/material.dart';

class Shelve with ChangeNotifier {
  String? _nome;
  int? _nrItens = 0;

  Shelve();

  Shelve.empty();

  String get nome => _nome!;
  int? get nrItens => _nrItens;

  setNome(String value) {
    _nome = value;
    notifyListeners();
  }

  setNrItens(int value) {
    _nrItens = value;
    notifyListeners();
  }

  Shelve.fromJson(Map<String, dynamic> json) {
    _nome = json["nome"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["nome"] = this._nome;

    return data;
  }
}
