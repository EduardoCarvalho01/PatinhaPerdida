import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'FeedPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerWithEmailAndPassword() async {
    // Verificar se algum campo está vazio
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ERRO DE REGISTRO'),
          content: Text('Por favor, preencha todos os campo!.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      // Registra o usuário com e-mail e senha
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Obtém o ID do usuário registrado
      String userId = userCredential.user!.uid;

      // Salva o nome do usuário no Firestore
      await _firestore.collection('users').doc(userId).set({
        'name': _nameController.text.trim(),
      });

      // Navega para a próxima tela após o registro bem-sucedido
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => FeedPage()));
    } catch (e) {
      print("Erro de Registro: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'PatinhaPerdida - Cadastro',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 134, 195, 245),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                prefixIcon: Icon(Icons.abc),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.password_outlined),
              ),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
            ElevatedButton.icon(
              onPressed: _registerWithEmailAndPassword,
              icon: Icon(Icons.check),
              label: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
