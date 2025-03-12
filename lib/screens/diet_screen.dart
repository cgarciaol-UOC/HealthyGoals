import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DietScreen extends StatefulWidget {
  @override
  _DietScreenState createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<Map<String, dynamic>> analyzeText(String inputText) async {
    final url = Uri.parse('http://127.0.0.1:8000/analizar-texto/');  //TODO cambiar el fastAPI local
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'texto': inputText}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Error al analizar el texto');
    }
  }

  // maneja el envío del texto
  void processDietInput() async {
    String inputText = _controller.text;
    try {
      // analiza el texto
      Map<String, dynamic> result = await analyzeText(inputText);
      // vamos a resultados y le pasamos el resultado del análisis
      context.go('/results', extra: result);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Problema al procesar el texto. Intentalo de nuevo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tu dieta y objetivos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Escribe tus preferencias alimentarias y tus objetivos'),
              maxLines: 5,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: processDietInput,
              child: Text('Generar Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
