import 'package:despensa/utils/AppPhoneSize.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  String? hintText, initialText, labelText;
  Function(String)? action, validator;
  CustomTextFormField(
      {Key? key,
      this.hintText,
      required this.labelText,
      this.action,
      this.validator,
      this.initialText})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen(context) / 1.7,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty || value == "") {
            return '';
          }
          return null;
        },
        // cursorColor: ,
        textAlign: TextAlign.center,
        initialValue: widget.initialText,
        // style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            fillColor: Colors.white,
            // border: OutlineInputBorder(),
            hintStyle: TextStyle(
              color: Colors.grey[500],
              // fontWeight: FontWeight.w100,
              fontSize: 14,
            ),
            hintText: widget.hintText ?? widget.labelText,
            labelText: widget.labelText),

        onChanged: widget.action ?? (value) {},
      ),
    );
  }
}
