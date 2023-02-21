import 'package:flutter/material.dart';

class DappText extends StatelessWidget {
  const DappText({Key? key}) : super(key: key);

  /// TODO: add shade700 to the grey color
  @override
  Widget build(BuildContext context) {
    return const Text(
      "Dapp",
      style: TextStyle(
          fontSize: 60, color: Colors.blueGrey, fontFamily: 'Bobbers'),
    );
  }
}
