import 'package:flutter/material.dart';
import 'package:flutter_app_food/screens/search_screen.dart';

class SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      child: TextField(
          controller: _controller,
          style: TextStyle(color: Colors.black, fontSize: 16.0),
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
              suffixIcon: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, SearchScreen.id,
                      arguments: _controller.text);
                  print(_controller.text);
                },
                child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                    )),
              ),
              border: InputBorder.none,
              hintText: "Search Foods")),
    );
  }
}
