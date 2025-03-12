import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FridgeScreen extends StatefulWidget {
  @override
  _FridgeScreenState createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  List<Map<String, dynamic>> _foods = [];
  List<Map<String, dynamic>> _fridge = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchFoods('fruta'); //TODO Change this for desired category
  }

  Future<void> _fetchFoods(String query) async {
    final url = Uri.parse('https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&json=true&lang=es');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List products = data['products'];

      setState(() {
        _foods = products
            .take(30) //TODO añadir mas paginas
            .map((item) => {
                  'name': item['product_name'] ?? 'Sin nombre',
                  'image': item['image_url'] ?? 'https://via.placeholder.com/150'
                })
            .toList();
      });
    } else {
      throw Exception('Error al cargar los alimentos');
    }
  }

  // Función para añadir a la nevera
  void _addToFridge(Map<String, dynamic> food) {
    setState(() {
      _fridge.add(food);  // Añadir el alimento a la lista de la nevera
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi nevera'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FridgeListScreen(fridge: _fridge),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                if (query.isNotEmpty) {
                  _fetchFoods(query); // Buscar alimentos cuando cambie el texto
                }
              },
              decoration: InputDecoration(
                hintText: 'Buscar alimento...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: _foods.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: _foods.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.network(
                            _foods[index]['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _foods[index]['name']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () => _addToFridge(_foods[index]),  // Llamada a la función
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class FridgeListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> fridge;

  FridgeListScreen({required this.fridge});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alimentos en la nevera'),
      ),
      body: fridge.isEmpty
          ? Center(child: Text('No hay alimentos en la nevera.'))
          : ListView.builder(
              itemCount: fridge.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(fridge[index]['image']!),
                  title: Text(fridge[index]['name']!),
                );
              },
            ),
    );
  }
}
