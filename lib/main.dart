import 'package:flutter/material.dart';
import './routes/HomePage.dart';
import 'constants.dart';

void main() {
  runApp(new ThirukuralApp());
}

final theme = new ThemeData(
  primarySwatch: Colors.deepPurple,
  fontFamily: 'NotoSansTamil',
);

class ThirukuralApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: kHomepageTitle,
      theme: theme,
      home: new HomePage(),
    );
  }
}
