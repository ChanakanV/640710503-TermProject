import 'package:flutter/material.dart';
import 'package:termproject/pages/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Term Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 136, 115, 6)),
        useMaterial3: true,
      ),
      home: BeerListPage(),
    );
  }
}
