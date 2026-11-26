import 'dart:convert';

import 'package:italiano/Aula05/Publicacao.dart';
import 'package:http/http.dart' as http;

Future<List<Publicacao>> carregar() async{
  final resposta = await http.get(Uri.http(
    'jsonplaceholder.typicode.com', '/posts'
  )).timeout(const Duration(seconds: 10));

  if(resposta.statusCode != 200){
    throw Exception('HTTP ${resposta.statusCode}');
  }
  final dados = jsonDecode(resposta.body);
  if(dados is! List) throw FormatException('Lista esperada');

  return dados.map((item) {
    if(item is! Map<String, dynamic>)
      throw const FormatException('Format invalido');
    return Publicacao.fromJson(item);
  }).toList();
}