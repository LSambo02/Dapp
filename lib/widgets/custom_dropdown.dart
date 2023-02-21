import 'package:despensa/utils/AppPhoneSize.dart';
import 'package:flutter/material.dart';

class CustomDropDownTextField extends StatefulWidget {
  Map<String, dynamic> items;
  dynamic currentSelectedValue;
  String? label;
  double width;
  var validacao, onChange, widthFactor, fontSize;
  Key? textKey;

  CustomDropDownTextField(
      {Key? key,
      required this.items,
      required this.currentSelectedValue,
      this.label,
      required this.width,
      this.validacao,
      this.onChange,
      this.widthFactor,
      this.fontSize,
      this.textKey})
      : super(key: key);
  @override
  _CustomDropDownTextFieldState createState() =>
      _CustomDropDownTextFieldState();
}

class _CustomDropDownTextFieldState extends State<CustomDropDownTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen(context) / 1.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label == null
              ? SizedBox()
              : Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  child: Container(
                    // width: widget.width / 1.2,
                    margin: EdgeInsets.only(bottom: 10, left: 12, right: 12),
                    child: Text(
                      widget.label!,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Container(
              width: widthScreen(context) / 1.15,
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(60),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<dynamic>(
                    dropdownColor: Colors.blueGrey,
                    // decoration: InputDecoration(
                    //   fillColor: Colors.blueGrey,
                    //   // border: OutlineInputBorder(
                    //   //   borderRadius: BorderRadius.circular(60),
                    //   //   // borderSide:
                    //   //   //     BorderSide(color: Colors.blueGrey, width: 0.0),
                    //   // ),
                    // ),
                    value: widget.currentSelectedValue,
                    // isDense: true,
                    onChanged: widget.onChange,
                    items: widget.items
                        .map((String handler, dynamic value) {
                          return MapEntry(
                            handler,
                            DropdownMenuItem<String>(
                              alignment: AlignmentDirectional.center,
                              value: handler,
                              child: new Text(
                                handler,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          );
                        })
                        .values
                        .toList(),
                    // validator: widget.validacao,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
