import 'package:italiano/Aula04/DetalhesLugar.dart';
import 'package:italiano/Aula04/Lugar.dart';
import 'package:flutter/material.dart';

class Guia extends StatelessWidget {
  const Guia({super.key});

  @override
  Widget build(BuildContext PgGuia) {
    const JardimBotanico = Lugar(
        'Jardim Botânico',
        'Tilhas e espaços verdes.'
    );

    const JardimBotanico2 = Lugar(
        'Jardim Botânico Sem Desc',
        null
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guia de Locais da Cidade"),
      ),
      body: Center(
        child: FilledButton(
          child: Text(JardimBotanico2.nome),
          // Metodo carregar nova página.
          onPressed: (){
            Navigator.push(PgGuia, MaterialPageRoute(
                builder: (_) => Detalheslugar(lugar: JardimBotanico2)
            ));
          },
        ),
      ),
    );
  }
}