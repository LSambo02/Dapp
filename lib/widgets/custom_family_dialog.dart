import 'package:flutter/material.dart';

import 'existing_family_dialog.dart';
import 'family_menu_dialog.dart';
import 'new_family_dialog.dart';

Widget familyDialog(BuildContext context) {
  return FamilyDialog(
      text1: 'Família Existente',
      text2: 'Criar Família',
      action1: () => showDialog(
          context: context,
          builder: (BuildContext context) => ExistingFamilyDialog()),
      action2: () => showDialog(
          context: context,
          builder: (BuildContext context) => NewFamilyDialog()));
}
