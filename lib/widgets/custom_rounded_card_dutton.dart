import 'package:flutter/material.dart';

class CustomRoundedLightButton extends StatelessWidget {
  String? text;
  IconData? icon;
  Function()? action;
  CustomRoundedLightButton(
      {Key? key, required this.text, required this.action, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.blue),
      ),
      child: Card(
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: ListTile(
            title: Text(text!),
            leading: Icon(icon!),
            onTap: action,
          ),
        ),
      ),
    );
  }
}
