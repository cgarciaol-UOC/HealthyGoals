import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> analizarTexto(String texto) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/analizar-texto/'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'texto': texto}),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al analizar el texto');
  }
}
