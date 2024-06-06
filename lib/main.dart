import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 29, 185, 178),
        fontFamily: 'Roboto',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String searchQuery = '';
  int itemCount = 0;

  void _buscarLivros() async {
    final url = Uri.https(
      'www.googleapis.com',
      'books/v1/volumes',
      {'q': searchQuery},
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        itemCount = jsonResponse['totalItems'];
      });
      print('Número de livros sobre "$searchQuery": $itemCount.');
    } else {
      print('Falha na requisição com status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesquisar Livros',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Digite o título do livro...',
                filled: true,
                fillColor: Color.fromARGB(255, 253, 253, 253),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _buscarLivros,
              icon: const Icon(Icons.search),
              label: const Text('Pesquisar'),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontWeight: FontWeight.bold),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Foram encontrados $itemCount livros sobre "$searchQuery":',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 48, 47, 47),
              ),
            )
          ],
        ),
      ),
    );
  }
}
