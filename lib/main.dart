import 'package:flutter/material.dart';

import 'caracter_list.dart';
import 'marvelTheme.dart';

void main() {
  runApp(MarvelApp());
}

class MarvelApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: marvelTheme,
      home: CaracterList(),
    );
  }
}


