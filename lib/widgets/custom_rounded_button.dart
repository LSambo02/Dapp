import 'package:despensa/utils/AppPhoneSize.dart';
import 'package:despensa/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  String? text;
  Function()? action;
  bool colorSwitch;
  CustomRoundedButton(
      {Key? key,
      required this.text,
      required this.action,
      this.colorSwitch = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen(context) / 2,
      child: ElevatedButton(
        child: Text(
          text!,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              color: colorSwitch ? Colors.white : shadesOfGrey[0],
              fontWeight: FontWeight.w800),
        ),
        onPressed: action,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            backgroundColor: colorSwitch
                ? MaterialStateProperty.all<Color>(shadesOfGrey[0])
                : MaterialStateProperty.all<Color>(Colors.white)),
      ),
    );
  }
}
