import 'package:despensa/models/Prateleira.dart';
import 'package:despensa/services/prateleira_service.dart';
import 'package:despensa/utils/GetIt.dart';
import 'package:flutter/material.dart';

import '../utils/AppPhoneSize.dart';
import 'custom_rounded_button.dart';
import 'custom_textformfield.dart';

class AddShelve extends StatelessWidget {
  double width;
  Shelve prateleira = Shelve.empty();
  TextEditingController minionNameController = TextEditingController();
  late GlobalKey<ScaffoldState> scaffoldKey;
  AddShelve({
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen(context),
      child: AlertDialog(
        backgroundColor: Color.fromRGBO(112, 128, 144, 1.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: Center(
            child: Text(
          'ADICONAR PRATELEIRA',
          style: TextStyle(fontSize: 20, color: Colors.white),
        )),
        content: Container(
            width: widthScreen(context) / 1.5,
            // height: heightScreen(context) / 6,
            child: CustomTextFormField(
              action: (value) => prateleira.setNome(value),
              hintText: 'Nome da Prateleira',
            )),
        actions: [
          Center(
            child: CustomRoundedButton(
                text: 'CONFIRMAR',
                action: () async {
                  getIt<PrateleiraService>()
                      .addShelve(prateleira)
                      .whenComplete(() {})
                      .then((value) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        duration: Duration(seconds: 3),
                        // backgroundColor: Colors.blue,
                      ),
                    );
                  });
                }),
          ),
        ],
      ),
    );
  }
}
