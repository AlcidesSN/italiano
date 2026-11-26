import 'package:italiano/Aula04/Guia.dart';
import 'package:flutter/material.dart';

class Aula04 extends StatelessWidget {
  const Aula04({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Guia(),
    );
  }
}
