
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/receita.dart';

class ReceitaService {
  static const String baseUrl =
      'https://receitasapi-b-2025.vercel.app';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<List<Receita>> listarReceitas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/receitas'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);

      return dados
          .map((item) => Receita.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList();
    }

    throw Exception(
      'Erro ao listar receitas: ${response.statusCode}',
    );
  }

  Future<Receita> buscarReceita(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/receitas/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Receita.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception(
      'Erro ao buscar receita: ${response.statusCode}',
    );
  }

  Future<void> cadastrarReceita(Receita receita) async {
    final response = await http.post(
      Uri.parse('$baseUrl/receitas'),
      headers: headers,
      body: jsonEncode(receita.toJson()),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        'Erro ao cadastrar receita: ${response.statusCode}',
      );
    }
  }

  Future<void> editarReceita(
    int id,
    Receita receita,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/receitas/$id'),
      headers: headers,
      body: jsonEncode(receita.toJson()),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      throw Exception(
        'Erro ao editar receita: ${response.statusCode}',
      );
    }
  }

  Future<void> excluirReceita(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/receitas/$id'),
      headers: headers,
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      throw Exception(
        'Erro ao excluir receita: ${response.statusCode}',
      );
    }
  }
}
