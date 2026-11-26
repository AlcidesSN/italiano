import 'dart:convert';

import 'package:http/http.dart' as http;

class RecipeService {
  static const String _baseUrl = 'dummyjson.com';
  static const Duration _timeout = Duration(seconds: 10);

  Future<List<Map<String, dynamic>>> listRecipes() async {
    final resposta = await http.get(
      Uri.http(_baseUrl, '/recipes'),
    ).timeout(_timeout);

    if (resposta.statusCode != 200) {
      throw Exception('HTTP ${resposta.statusCode}');
    }

    final dados = jsonDecode(resposta.body);
    if (dados is! Map<String, dynamic>) {
      throw const FormatException('Corpo inválido');
    }

    final receitasJson = dados['recipes'];
    if (receitasJson is! List) {
      throw const FormatException('Lista de receitas esperada');
    }

    return receitasJson.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> searchRecipes(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      throw const FormatException('Consulta vazia');
    }

    final resposta = await http.get(
      Uri.http(_baseUrl, '/recipes/search', {'q': q}),
    ).timeout(_timeout);

    if (resposta.statusCode != 200) {
      throw Exception('HTTP ${resposta.statusCode}');
    }

    final dados = jsonDecode(resposta.body);
    if (dados is! Map<String, dynamic>) {
      throw const FormatException('Corpo inválido');
    }

    final receitasJson = dados['recipes'];
    if (receitasJson is! List) {
      throw const FormatException('Lista de receitas esperada');
    }

    return receitasJson.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getRecipe(int id) async {
    final resposta = await http.get(
      Uri.http(_baseUrl, '/recipes/$id'),
    ).timeout(_timeout);

    if (resposta.statusCode != 200) {
      throw Exception('HTTP ${resposta.statusCode}');
    }

    final dados = jsonDecode(resposta.body);
    if (dados is! Map<String, dynamic>) {
      throw const FormatException('Corpo inválido');
    }

    return dados;
  }
}
