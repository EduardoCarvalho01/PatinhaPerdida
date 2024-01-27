import 'package:flutter/material.dart';

class DetalhesPostPage extends StatelessWidget {
  final String imageUrl;
  final String corPelagem;
  final String userName;
  final bool animalDocil;
  final String localizacao;
  final String data;

  // Modifica o construtor para aceitar um bool e convertê-lo para uma string
  DetalhesPostPage({
    required this.imageUrl,
    required this.corPelagem,
    required this.userName,
    required this.animalDocil,
    required this.localizacao,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Post'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('ImageUrl:', imageUrl),
            _buildDetailItem('Cor da Pelagem:', corPelagem),
            _buildDetailItem('Nome do Usuário:', userName),
            // Converte o valor booleano em uma string antes de passá-lo
            _buildDetailItem('Animal Docil:', animalDocil.toString()),
            _buildDetailItem('Localização:', localizacao),
            _buildDetailItem('Data:', data),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              value,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
