import 'package:flutter/material.dart';

class Inscricao extends StatefulWidget {
  const Inscricao({super.key});

  @override
  State<Inscricao> createState() => _InscricaoState();
}

class _InscricaoState extends State<Inscricao> {
  final nome =  TextEditingController();
  String? mensagemErro;


  void validarNome(String valor){
    setState(() {


      if(valor.trim().isEmpty){
        mensagemErro =  "Informe seu nome";
      }else if (valor.trim().length < 3){
        mensagemErro = "Informe ao menos 3 caracteres";
      }else{
        mensagemErro = null;
      }
    });
  }
  
  void inscrever(){
    validarNome(nome.text);
    if(mensagemErro != null) return;
    
    final text = nome.text.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Inscrição Recebida: $text"))
    );

    nome.clear();
  }

  @override
  void dispose() {
    nome.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Palestra"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nome,
              decoration: InputDecoration(
                labelText: "Nome Completo",
                errorText: mensagemErro,
                border: const OutlineInputBorder()
              ),
              onChanged: (valor) {
                if (mensagemErro != null) validarNome(valor);
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: inscrever,
              child: Text("Inscrever"))
          ],

        ),
      ),
    );
  }
}
