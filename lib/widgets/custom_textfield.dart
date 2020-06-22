import 'package:flutter/material.dart';
import 'package:flutter_app_food/const.dart';

class CustomTextField extends StatelessWidget {
  final String value;
  final String hint;
  final IconData icon;
  final Function onClick;

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

  CustomTextField(
      {@required this.onClick,
      @required this.icon,
      @required this.hint,
      this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        // ignore: missing_return
        validator: (value) {
          if (value.isEmpty) {
            return _errorMessage(hint);
          }
        },
        onSaved: onClick,
        obscureText: hint == 'Enter your password' ? true : false,
        initialValue: value,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: primaryColor,
          ),
          filled: true,
          fillColor: primaryColorLight,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}
