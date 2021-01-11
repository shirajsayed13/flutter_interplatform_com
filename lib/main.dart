import 'package:flutter/material.dart';
import 'MultiGallerySelectPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xff99FFFF),
          primaryColorDark: Color(0xff00FFFF),
          accentColor: Color(0xffE5FFCC)),
      home: MultiGallerySelectPage(),
    );
  }
}
