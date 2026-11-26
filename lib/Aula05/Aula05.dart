import 'package:flutter/material.dart';
import 'package:italiano/Aula05/Mural.dart';

class Aula05 extends StatelessWidget {
  const Aula05({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Mural(),
    );
  }
}
