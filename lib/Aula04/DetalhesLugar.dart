import 'package:italiano/Aula04/Guia.dart';
import 'package:flutter/material.dart';
import 'package:italiano/Aula04/Lugar.dart';

class Detalheslugar extends StatelessWidget {
  const Detalheslugar({super.key, required this.lugar });
  final Lugar lugar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lugar.nome),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(lugar.descricao ?? 'Descricação Indisponível'),
            const SizedBox(height: 20,),
            OutlinedButton(
              child: const Text('Voltar ao Guia'),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}