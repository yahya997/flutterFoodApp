import 'package:flutter/material.dart';

class CustomTextFieldProfile extends StatelessWidget {
  final bool status;
  final String value;
  final String hint;
  final Function onClick;

  CustomTextFieldProfile(
      {@required this.onClick,
      @required this.hint,
      this.value,
      this.status});

  String _errorMessage(String str) {
    switch (hint) {
      case 'Enter your name':
        return 'Name is empty !';
      case 'Enter your address':
        return 'Address is empty !';
      case 'Enter your phone':
        return 'Phone is empty !';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // ignore: missing_return
      validator: (value) {
        if (value.isEmpty) {
          return _errorMessage(hint);
        }
      },
      onSaved: onClick,
      initialValue: value,
      decoration:  InputDecoration(
        hintText: hint,
      ),
      enabled: !status,
      autofocus: !status,
    );
  }
}
