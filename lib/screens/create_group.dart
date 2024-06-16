import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../models/organizer.dart';
import '../providers/organizer_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart'; // Importar Logger
import 'package:flutter/foundation.dart'; // Importar kDebugMode

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _logoPath = '';
  String _title = 'Ningún organizador';
  final Logger _logger = Logger(); // Instancia de Logger

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _logoPath = pickedFile.path;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _logoPath = '';
    });
  }

  void _createOrganizer() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final organizer = Organizer(
        name: _nameController.text,
        bio: _bioController.text,
        logoPath: _logoPath,
        email: _emailController.text,
        phone: _phoneController.text,
      );
      await Provider.of<OrganizerProvider>(context, listen: false).addOrganizer(organizer);
      setState(() {
        _title = 'Organizador Creado';
      });
    } else {
      if (kDebugMode) {
        _logger.e("User not authenticated"); // Uso de Logger en modo debug
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del organizador',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Biografía (0/1000 caracteres)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Text('Logotipo'),
            if (_logoPath.isNotEmpty)
              Image.file(File(_logoPath)),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
                foregroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Desde la cámara'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
                foregroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Desde galería'),
            ),
            ElevatedButton(
              onPressed: _removeImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
                foregroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Eliminar logotipo'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createOrganizer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('+ CREAR ORGANIZADOR'),
            ),
          ],
        ),
      ),
    );
  }
}
