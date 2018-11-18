import 'package:flutter/material.dart';
import './routes/HomePage.dart';
import 'constants.dart';
import 'colors.dart';
import './bloc/KuralProvider.dart';
import './bloc/KuralBloc.dart';

void main() {
  runApp(new ThirukuralApp());
}

final ThemeData _kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'NotoSansTamil',
  );
  return base.copyWith(
    accentColor: Colors.deepPurpleAccent,
//    accentColor: kShrineBrown900,
    primaryColor: Colors.deepPurple[700],
    buttonColor: kShrinePink100,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
    // TODO: Add the text themes (103)
    // TODO: Add the icon themes (103)
    // TODO: Decorate the inputs (103)
  );
}

final lightTheme = new ThemeData(
  primarySwatch: Colors.deepPurple,
  accentColor: Colors.deepPurpleAccent,
  fontFamily: 'NotoSansTamil',
  buttonColor: Colors.deepPurple[300]
);

// https://www.uplabs.com/posts/dark-material-ui-design
const haiti = const Color(0xFF25252F);
const haitiDarker = const Color(0xFF1F1D24);
const trendyPink = const Color(0xFF8C5F8C);
const mantle = const Color(0xFFA2A4A2);
const cadetBlue = const Color(0xFF51A1A7);
const havelockBlue = const Color(0xFF6383C4);
const appleGreen = const Color(0xFFE4E7E3);

// https://dribbble.com/shots/4286418-Blockchain-AI-Cryptocurrency-Landing-Page
const purpleDark = const Color(0xFF242072);
const purple = const Color(0xFF322379);
const accent = const Color(0xFFFDFDFD);
const cardColor = const Color(0xFFB3C2EA);

final darkTheme = new ThemeData(
  fontFamily: 'NotoSansTamil',
  brightness: Brightness.dark,
  primaryColor: purple,
  canvasColor: purple,
  accentColor: accent,
  cardColor: purple,
  scaffoldBackgroundColor: purpleDark,
);

class ThirukuralApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KuralProvider(
      kuralBloc: KuralBloc(context),
      child: new MaterialApp(
        title: kHomepageTitle,
//      theme: darkTheme,
        theme: _kShrineTheme,
        home: new HomePage(),
      ),
    );
  }
}
