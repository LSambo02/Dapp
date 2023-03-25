import 'dart:developer';

import 'package:despensa/models/ListaCompras.dart';
import 'package:despensa/services/lista_compras_service.dart';
import 'package:despensa/widgets/custom_rounded_button.dart';
import 'package:despensa/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Produto.dart';
import '../utils/AppPhoneSize.dart';
import '../utils/GetIt.dart';

class SaveDialog extends StatefulWidget {
  List? lista;

  SaveDialog(
    this.lista, {
    Key? key,
  }) : super(key: key);

  @override
  State<SaveDialog> createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  ListaCompras listaCompras = ListaCompras.empty();
  DateTime now = DateTime.now();
  final dateF = new DateFormat('dd-MM-yyyy HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    final date = dateF.format(now);
    listaCompras.setNomeLista('Lista $date');
    return Container(
      width: widthScreen(context),
      child: AlertDialog(
        backgroundColor: Color.fromRGBO(112, 128, 144, 1.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        title: Center(
          child: Text(
            'Família',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        content: Container(
          height: heightScreen(context) / 6,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                width: widthScreen(context) / 1.2,
                child: CustomTextFormField(
                  hintText: "Nome da Lista",
                  initialText: 'Lista $date',
                  action: (value) {
                    listaCompras.setNomeLista(value);
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomRoundedButton(
                  text: 'Criar',
                  action: () {
                    List list = [];
                    for (Produto p in widget.lista!) {
                      list.add(p.toJson());
                    }
                    log('custom_save_dialog.dart::: ${widget.lista![0].nome}');
                    listaCompras.setLista(list);

                    getIt<ListaComprasService>()
                        .addListaCompras(listaCompras)
                        .whenComplete(() {})
                        .then((value) {
                      print(value);
                      setState(() {});
                      Navigator.pop(context);
                      // Navigator.pushNamedAndRemoveUntil(context,
                      //     dashboard_screen, (Route<dynamic> route) => false);
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
