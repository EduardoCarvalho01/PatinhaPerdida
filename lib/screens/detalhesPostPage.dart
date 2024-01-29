import 'package:flutter/material.dart';

class DetalhesPostPage extends StatelessWidget {
  final String imageUrl;
  final String corPelagem;
  final String userName;
  final bool animalDocil;
  final String localizacao;
  final String data;

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
        title: const Center(
          child: Text(
            'Detalhes do Post',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 134, 195, 245),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.image_not_supported, size: 50),
            _buildDetailItem('Cor da Pelagem:', corPelagem),
            _buildDetailItem('Nome do Usuário:', userName),
            _buildDetailItem('Animal Docil:', animalDocil ? 'Sim' : 'Não'),
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
