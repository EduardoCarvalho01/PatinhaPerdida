import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'FeedPage.dart';
import 'LoginPage.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'PatinhaPerdida - Home',
            style: TextStyle(color: Colors.black),
          ),
        ),
        
        
        backgroundColor: Color.fromARGB(255, 134, 195, 245),
      ),
      backgroundColor: Colors.lightGreen[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              icon: Icon(Icons.login), 
              label: Text('Login '),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              icon: Icon(Icons.person_add), 
              label: Text('Registrar'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedPage()),
                );
              },
              icon: Icon(Icons.feed), 
              label: Text('Visitante'),
            ),
          ],
        ),
      ),
    );
  }
}
