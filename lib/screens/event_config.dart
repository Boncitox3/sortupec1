import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import 'sorteos.dart';
import 'location_screen.dart';

class EventConfigScreen extends StatefulWidget {
  final Function(SorteoEvent event) onCreateEvent;
  final String? initialTitle;
  final String? initialDescription;
  final String? initialDate;
  final String? initialLocation;

  const EventConfigScreen({
    required this.onCreateEvent,
    this.initialTitle,
    this.initialDescription,
    this.initialDate,
    this.initialLocation,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventConfigScreenState createState() => _EventConfigScreenState();
}

class _EventConfigScreenState extends State<EventConfigScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _durationController;
  late TextEditingController _capacityController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  String _logoPath = '';
  bool _acceptTerms = false;
  String? _selectedEventType;
  String? _selectedCurrency;

  final List<String> _eventTypes = [
    'Gastronomía', 'Artes', 'Fiesta', 'Sorteo', 'Rifas', 'Transporte', 
    'Obra de Teatro', 'Reunión', 'Deporte', 'Feria', 'Cursos', 'Concierto'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _dateController = TextEditingController(text: widget.initialDate);
    _timeController = TextEditingController();
    _durationController = TextEditingController();
    _capacityController = TextEditingController();
    _locationController = TextEditingController(text: widget.initialLocation);
    _priceController = TextEditingController();  // Inicializar el controlador del precio
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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

  void _saveEvent() async {
    if (_acceptTerms) {
      SorteoEvent event = SorteoEvent(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _dateController.text,
        time: _timeController.text,
        duration: _durationController.text,
        capacity: _capacityController.text,
        location: _locationController.text,
        logoPath: _logoPath,
        eventType: _selectedEventType ?? '',
        currency: _selectedCurrency ?? '',
        price: _priceController.text,  // Añadir el precio
      );
      await Provider.of<EventProvider>(context, listen: false).addEvent(event);
      if (mounted) {
        widget.onCreateEvent(event);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _openLocationScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationScreen(
          locationController: _locationController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración del evento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedEventType,
              decoration: const InputDecoration(
                labelText: 'Tipo de Evento *',
                border: OutlineInputBorder(),
              ),
              items: _eventTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEventType = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Fecha *',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    _dateController.text = formattedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Hora *',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _timeController.text = pickedTime.format(context);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duración *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _capacityController,
              decoration: const InputDecoration(
                labelText: 'Aforo *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Ubicación *',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: _openLocationScreen,
            ),
            const SizedBox(height: 16),
            const Text('Logotipo'),
            if (_logoPath.isNotEmpty)
              Image.file(File(_logoPath), height: 200, fit: BoxFit.cover),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Seleccionar imagen'),
            ),
            ElevatedButton(
              onPressed: _removeImage,
              child: const Text('Eliminar logotipo'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
                labelText: 'Precio *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Acepto las condiciones de uso'),
              value: _acceptTerms,
              onChanged: (value) {
                setState(() {
                  _acceptTerms = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('GUARDAR CAMBIOS'),
            ),
          ],
        ),
      ),
    );
  }
}
