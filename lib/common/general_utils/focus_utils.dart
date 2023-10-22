import 'package:flutter/material.dart';

unFocus(BuildContext context) {
  FocusScopeNode currentScope = FocusScope.of(context);
  if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}



class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}