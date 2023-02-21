import 'package:despensa/utils/AppPhoneSize.dart';
import 'package:despensa/widgets/custom_rounded_button.dart';
import 'package:flutter/material.dart';

class FamilyDialog extends StatefulWidget {
  final String? text1, text2;
  final Function()? action1, action2;
  FamilyDialog(
      {Key? key,
      required this.text1,
      required this.text2,
      required this.action1,
      required this.action2})
      : super(key: key);

  @override
  State<FamilyDialog> createState() => _FamilyDialogState();
}

class _FamilyDialogState extends State<FamilyDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 10,
      width: MediaQuery.of(context).size.width,
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
          margin: EdgeInsets.only(top: 30),
          height: heightScreen(context) / 6,
          child: Column(
            children: [
              CustomRoundedButton(text: widget.text1, action: widget.action1),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  'OU',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              CustomRoundedButton(text: widget.text2, action: widget.action2)
            ],
          ),
        ),
      ),
    );
  }
}
