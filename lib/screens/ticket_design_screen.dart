import 'dart:io';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class TicketDesignScreen extends StatefulWidget {
  const TicketDesignScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TicketDesignScreenState createState() => _TicketDesignScreenState();
}

class _TicketDesignScreenState extends State<TicketDesignScreen> {
  String? _backgroundImagePath;
  bool _showEventDetails = true;
  double _qrPositionX = 0.5;
  double _qrPositionY = 0.5;


  Future<void> _downloadTemplate() async {
    final tempDir = await getTemporaryDirectory();
    final templateFile = File('${tempDir.path}/template.png');
    // Aquí deberías crear la imagen de la plantilla. Por ahora, es solo una imagen en blanco.
    final imageBytes = List<int>.filled(1020 * 510, 0xFFFFFFFF); // Imagen blanca
    templateFile.writeAsBytes(imageBytes);

    // Aquí puedes implementar la lógica para guardar o compartir la plantilla
    // Dependiendo de tus requerimientos específicos.
  }

  void _moveQR(String direction) {
    setState(() {
      switch (direction) {
        case 'up':
          _qrPositionY = (_qrPositionY - 0.05).clamp(0.0, 1.0);
          break;
        case 'down':
          _qrPositionY = (_qrPositionY + 0.05).clamp(0.0, 1.0);
          break;
        case 'left':
          _qrPositionX = (_qrPositionX - 0.05).clamp(0.0, 1.0);
          break;
        case 'right':
          _qrPositionX = (_qrPositionX + 0.05).clamp(0.0, 1.0);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diseño de la entrada'),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.crop_landscape, size: 40),
                    SizedBox(height: 8),
                    Text('HORIZONTAL\n1020X510', textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.crop_portrait, size: 40),
                    SizedBox(height: 8),
                    Text('VERTICAL\n510X1020', textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                _backgroundImagePath != null
                    ? Image.file(
                        File(_backgroundImagePath!),
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            '¡No has escogido ninguna imagen de fondo!',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                Positioned(
                  left: MediaQuery.of(context).size.width * _qrPositionX - 50, // Ajusta según tu diseño
                  top: 200 * _qrPositionY - 50, // Ajusta según tu diseño
                  child: const Icon(Icons.qr_code, size: 50),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _downloadTemplate,
              child: const Text('DESCARGAR PLANTILLA'),
            ),
            const SizedBox(height: 16),
            const Text('Posición del QR', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: () {
                    _moveQR('up');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  onPressed: () {
                    _moveQR('down');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    _moveQR('left');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    _moveQR('right');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Mostrar datos del evento'),
              value: _showEventDetails,
              onChanged: (value) {
                setState(() {
                  _showEventDetails = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Si activas esta opción, las entradas se generarán con toda la información del evento.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Guardar el diseño
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('GUARDAR DISEÑO'),
            ),
          ],
        ),
      ),
    );
  }
}
