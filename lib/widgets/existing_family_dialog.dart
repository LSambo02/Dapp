import 'package:flutter/material.dart';

import '../models/Familia.dart';
import '../services/familia_service.dart';
import '../utils/AppPhoneSize.dart';
import '../utils/GetIt.dart';
import '../utils/constantes.dart';
import '../utils/sharedPreferences.dart';
import 'custom_rounded_button.dart';
import 'custom_textformfield.dart';

class ExistingFamilyDialog extends StatefulWidget {
  String? dropdownValue;

  ExistingFamilyDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ExistingFamilyDialog> createState() => _ExistingFamilyDialogState();
}

class _ExistingFamilyDialogState extends State<ExistingFamilyDialog> {
  Familia familia = Familia.empty();
  String? familiaId;
  final _formKey = GlobalKey<FormState>();
  Future<Map<String, dynamic>>? familiaService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    familiaService = getIt<FamiliaService>().getUserFamilies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen(context),
      child: AlertDialog(
        contentPadding: EdgeInsets.all(0),
        backgroundColor: Color.fromRGBO(112, 128, 144, 1.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        title: Center(
            child: Text(
          'Família',
          style: TextStyle(fontSize: 20, color: Colors.white),
        )),
        content: Container(
          height: heightScreen(context) / 4,
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                    future: familiaService,
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      print('P' + snapshot.data.toString());
                      if (snapshot.hasError) {
                        return Text('SEM FAMILIAS');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text("SEM DADOS"),
                        );
                      } else {
                        Map<String, dynamic> familias = snapshot.data!;

                        if (familias.isNotEmpty) {
                          widget.dropdownValue = familias.keys.toList()[0];
                          familiaId = familias[widget.dropdownValue];
                        }

                        return familias.isNotEmpty
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                width: widthScreen(context) / 1.5,
                                child: Container(
                                  decoration: ShapeDecoration(
                                    color: Colors.blueGrey[600],
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.0, style: BorderStyle.none),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 30),
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButtonFormField<String>(
                                          value: widget.dropdownValue,
                                          dropdownColor: Colors.blueGrey,
                                          items: snapshot.data?.keys
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              value: value,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 18.0, left: 18.0),
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onSaved: (String? newValue) {
                                            // getIt<UserState>().saveFamilyId(snapshot.data?[newValue]);
                                            // print(value);

                                            setState(() {
                                              widget.dropdownValue = newValue!;
                                              familiaId = familias[newValue];
                                              // _isLoadingGSignIn = false;
                                              // _isDoneSignIn = true;
                                              // _message = value;
                                            });
                                          },
                                          onChanged: (String? newValue) {
                                            // getIt<UserState>().saveFamilyId(snapshot.data?[newValue]);
                                            // print(value);

                                            setState(() {
                                              widget.dropdownValue = newValue!;
                                              familiaId = familias[newValue];
                                              // _isLoadingGSignIn = false;
                                              // _isDoneSignIn = true;
                                              // _message = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox();
                      }
                    }),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: widthScreen(context) / 1.2,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: CustomTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "") {
                        return '';
                      }
                      return null;
                    },
                    hintText: "Entrar pelo código",
                    action: (value) {
                      familiaId = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomRoundedButton(
                    text: 'Entrar na Família',
                    action: () {
                      if (_formKey.currentState!.validate()) {
                        if (_formKey.currentState!.validate()) {
                          getIt<FamiliaService>()
                              .addFamiliaToUser(familiaId!)
                              .whenComplete(() {})
                              .then((value) {
                            getIt<UserState>().saveFamilyId(familiaId);

                            print(value);
                            setState(() {
                              // _isLoadingGSignIn = false;
                              // _isDoneSignIn = true;
                              // _message = value;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value,
                                      overflow: TextOverflow.fade,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                duration: Duration(seconds: 3),
                                // backgroundColor: Colors.blue,
                              ),
                            );

                            if (value == 'Faz agora parte da Família, Parabéns')
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  dashboard_screen,
                                  (Route<dynamic> route) => false);
                          });
                        }
                      } else {
                        getIt<UserState>().saveFamilyId(familiaId);
                        Navigator.pushNamedAndRemoveUntil(context,
                            dashboard_screen, (Route<dynamic> route) => false);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
