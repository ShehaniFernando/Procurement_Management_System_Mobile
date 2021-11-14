import 'package:flutter/material.dart';

class ButtonHeaderWidget extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onClicked;

  const ButtonHeaderWidget(
      {Key? key,
      required this.title,
      required this.text,
      required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonHeaderWidget(title: title, text: text, onClicked: onClicked);
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({Key? key, required this.text, required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(40), primary: Colors.white),
        onPressed: onClicked,
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ));
  }
}
