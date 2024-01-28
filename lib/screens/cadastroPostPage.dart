import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';

enum Porte { Pequeno, Medio, Grande }

class CadastroPostPage extends StatefulWidget {
  final String userName;

  CadastroPostPage({required this.userName});

  @override
  _CadastroPostPageState createState() => _CadastroPostPageState();
}

class _CadastroPostPageState extends State<CadastroPostPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String currentUserUid;
  bool possuiColeira = false;
  String corPelagem = '';
  Porte porte = Porte.Pequeno;
  bool animalDocil = false;
  bool apresentaMachucado = false;
  String descricaoMachucado = '';
  XFile? _pickedImage;
  Position? _currentPosition;
  String? _address;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserUid = user.uid;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });

      if (_currentPosition != null) {
        _getAddressFromLatLng();
      }
    } catch (e) {
      print("Erro ao obter a localização: $e");
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _address = "${place.street}, ${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      print("Erro ao obter o endereço: $e");
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      // Se a permissão estiver negada, solicite-a
      await Permission.location.request();
    }
  }

  Future<void> _saveDataToFirebase() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      // Upload da imagem para o Firebase Storage
      if (_pickedImage != null) {
        firebase_storage.UploadTask task = storage
            .ref('images/${DateTime.now().toString()}.jpg')
            .putFile(File(_pickedImage!.path));
        await task.whenComplete(() => null);

        // Obtém a URL da imagem no Firebase Storage
        String imageUrl = await task.snapshot.ref.getDownloadURL();

        // Salva os dados no Firestore, incluindo o nome do usuário e a URL da imagem
        await firestore.collection('posts').add({
          'userId': currentUserUid,
          'userName': widget.userName, // Adiciona o nome do usuário
          'possuiColeira': possuiColeira,
          'corPelagem': corPelagem,
          'porte': porte.toString().split('.').last,
          'animalDocil': animalDocil,
          'apresentaMachucado': apresentaMachucado,
          'descricaoMachucado': descricaoMachucado,
          'latitude': _currentPosition?.latitude,
          'longitude': _currentPosition?.longitude,
          'endereco': _address,
          'imageUrl': imageUrl, // Adiciona a URL da imagem no Firestore
          'data': Timestamp.now(), // Adiciona a data atual
        });
      } else {
        // Se não houver imagem, salva os dados sem a URL da imagem
        await firestore.collection('posts').add({
          'userId': currentUserUid,
          'userName': widget.userName, // Adiciona o nome do usuário
          'possuiColeira': possuiColeira,
          'corPelagem': corPelagem,
          'porte': porte.toString().split('.').last,
          'animalDocil': animalDocil,
          'apresentaMachucado': apresentaMachucado,
          'descricaoMachucado': descricaoMachucado,
          'latitude': _currentPosition?.latitude,
          'longitude': _currentPosition?.longitude,
          'endereco': _address,
          'data': Timestamp.now(), // Adiciona a data atual
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Dados salvos com sucesso no Firebase Firestore e Firebase Storage!'),
        ),
      );
    } catch (error) {
      print('Erro ao salvar dados no Firebase: $error');
    }
  }

  Widget _buildImagePreview() {
    return _pickedImage != null
        ? Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(_pickedImage!.path)),
                fit: BoxFit.cover,
              ),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    _checkLocationPermission();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'PatinhaPerdida - Cadastro do Post',
            style: TextStyle(
                color: Colors
                    .white), // Adicione esta linha para definir a cor do texto
          ),
        ),
        backgroundColor: Colors
            .blue, // Adicione esta linha para definir a cor do fundo do AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Possui Coleira?'),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: possuiColeira,
                    onChanged: (value) {
                      setState(() {
                        possuiColeira = value as bool;
                      });
                    },
                  ),
                  Text('Sim'),
                  Radio(
                    value: false,
                    groupValue: possuiColeira,
                    onChanged: (value) {
                      setState(() {
                        possuiColeira = value as bool;
                      });
                    },
                  ),
                  Text('Não'),
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    corPelagem = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Cor da Pelagem'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<Porte>(
                value: porte,
                onChanged: (value) {
                  setState(() {
                    porte = value!;
                  });
                },
                items: Porte.values
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value.toString().split('.').last),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Porte'),
              ),
              SizedBox(height: 16.0),
              CheckboxListTile(
                title: Text('Animal Dócil'),
                value: animalDocil,
                onChanged: (value) {
                  setState(() {
                    animalDocil = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              CheckboxListTile(
                title: Text('Apresenta Machucado'),
                value: apresentaMachucado,
                onChanged: (value) {
                  setState(() {
                    apresentaMachucado = value!;
                  });
                },
              ),
              apresentaMachucado
                  ? TextField(
                      onChanged: (value) {
                        setState(() {
                          descricaoMachucado = value;
                        });
                      },
                      decoration:
                          InputDecoration(labelText: 'Descrição do Machucado'),
                    )
                  : Container(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: Text('Obter Localização'),
              ),
              _currentPosition != null
                  ? Text(
                      'Localização: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}')
                  : Container(),
              _address != null ? Text('Endereço: $_address') : Container(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Escolha uma opção'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _getImage(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                              child: Text('Câmera'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _getImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                              child: Text('Galeria'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text('Selecionar Imagem'),
              ),
              _buildImagePreview(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _saveDataToFirebase(); // Chamada para salvar dados no Firebase Firestore
                  Navigator.pop(
                      context); // Volta para a tela anterior após salvar
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
