import 'package:flutter/material.dart';
import 'package:italiano/Aula05/Publicacao.dart';
import 'package:italiano/Aula05/Utils.dart';

class Mural extends StatefulWidget {
  const Mural({super.key});

  @override
  State<Mural> createState() => _MuralState();
}

class _MuralState extends State<Mural> {
  late Future<List<Publicacao>> publis;

  @override
  void initState(){
    super.initState();
    publis = carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mural de Publicaçoẽs'),),
      body: FutureBuilder<List<Publicacao>>(
          future: publis,
          builder: (context, estado){
            if(estado.connectionState != ConnectionState.done){
              return const Center(child: CircularProgressIndicator(),);
            }
            if(estado.hasError){
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Não foi possivel abrir o Mural.'),
                    FilledButton(
                        onPressed: () => setState(() => publis = carregar()),
                        child: const Text('Tentar Novamente'))
                  ],
                ),
              );
            }
            final itens = estado.data ?? <Publicacao> [];

            if(itens.isEmpty){
              return const Center(child: Text('Sem Publicaçoẽs'),);
            }
            return ListView.builder(
              itemCount: itens.length,
              itemBuilder: (_,i) => ListTile(
                title: Text(itens[i].titulo),
                subtitle: Text('Publicação ${itens[i].id}'),
            )
            );
          }),
    );
  }
}
