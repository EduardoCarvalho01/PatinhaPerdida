import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';
import 'FeedPage.dart'; // Importe a FeedPage

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'PatinhaPerdida - Home',
            style: TextStyle(
                color: Colors
                    .black), // Adicione esta linha para definir a cor do texto
          ),
        ),
        backgroundColor: Color.fromARGB(255, 134, 195,
            245), // Adicione esta linha para definir a cor do fundo do AppBar
      ),
      backgroundColor: Colors.lightGreen[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(Icons.login), // Ícone de Login
              label: Text('Login'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              icon: Icon(Icons.person_add), // Ícone de Registrar
              label: Text('Registrar'),
            ),
            SizedBox(height: 16.0), // Adicione um espaçamento entre os botões
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedPage()));
              },
              icon: Icon(Icons.feed), // Ícone de Feed de Notícias
              label: Text('Feed de Notícias'),
            ),
          ],
        ),
      ),
    );
  }
}
