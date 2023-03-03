import 'package:despensa/widgets/custom_rounded_button.dart';
import 'package:despensa/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';

import '../models/Familia.dart';
import '../services/auth_service.dart';
import '../services/familia_service.dart';
import '../utils/AppPhoneSize.dart';
import '../utils/GetIt.dart';
import '../utils/constantes.dart';

class NewFamilyDialog extends StatefulWidget {
  NewFamilyDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<NewFamilyDialog> createState() => _NewFamilyDialogState();
}

class _NewFamilyDialogState extends State<NewFamilyDialog> {
  Familia familia = Familia.empty();

  @override
  Widget build(BuildContext context) {
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
                  hintText: "Nome da Família",
                  action: (value) {
                    familia.setNome(value);
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomRoundedButton(
                  text: 'Criar',
                  action: () {
                    familia.setOwner(getIt<AuthService>().userId);

                    getIt<FamiliaService>()
                        .addFamily(familia)
                        .whenComplete(() {})
                        .then((value) {
                      print(value);
                      setState(() {
                        // _isLoadingGSignIn = false;
                        // _isDoneSignIn = true;
                        // _message = value;
                      });
                      Navigator.pushNamedAndRemoveUntil(context,
                          dashboard_screen, (Route<dynamic> route) => false);
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
