import 'package:flutter/material.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextPage(context, page, {Object? argument}) {
  Navigator.pushNamed(context, page, arguments: argument);
}

void nextScreenReplacement(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void nextPageRemove(BuildContext context, String page) {
  Navigator.pushReplacementNamed(context, page);
}

void nextPageRemoveAll(BuildContext context, String page) {
  Navigator.pushNamedAndRemoveUntil(context, page, (route) => false);
}
