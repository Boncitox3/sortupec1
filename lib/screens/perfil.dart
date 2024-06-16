import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_group.dart'; // Importa la pantalla CreateGroup
import '../providers/organizer_provider.dart'; // Importa el OrganizerProvider

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ningún grupo organizador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Agrega tu lógica para el menú aquí
            },
          ),
        ],
      ),
      body: Consumer<OrganizerProvider>(
        builder: (context, organizerProvider, child) {
          return organizerProvider.organizers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¡Crea un grupo organizador para empezar!',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CreateGroup()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('+ CREAR GRUPO NUEVO'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: organizerProvider.organizers.length,
                  itemBuilder: (context, index) {
                    final organizer = organizerProvider.organizers[index];
                    return ListTile(
                      leading: organizer.logoPath.isNotEmpty
                          ? Image.file(File(organizer.logoPath))
                          : null,
                      title: Text(organizer.name),
                      subtitle: Text(organizer.bio),
                    );
                  },
                );
        },
      ),
    );
  }
}
