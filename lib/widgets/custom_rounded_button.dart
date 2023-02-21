import 'package:despensa/utils/AppPhoneSize.dart';
import 'package:despensa/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  String? text;
  Function()? action;
  CustomRoundedButton({Key? key, required this.text, required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen(context) / 2,
      child: ElevatedButton(
        child: Text(
          text!,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: shadesOfGrey[0]),
        ),
        onPressed: action,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
      ),
    );
  }
}
