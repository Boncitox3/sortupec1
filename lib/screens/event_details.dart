import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/event.dart';
import 'event_config.dart';
import 'ticket_design_screen.dart';
import 'manage_session_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  final Function(Event) onUpdateEvent;

  const EventDetailsScreen({required this.event, required this.onUpdateEvent, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Event event;

  @override
  void initState() {
    super.initState();
    event = widget.event;
  }

  void _updateEvent(Event updatedEvent) {
    setState(() {
      event = updatedEvent;
    });
    widget.onUpdateEvent(updatedEvent);
  }

  void _showShareOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Cómo quieres compartir el evento?'),
          actions: [
            TextButton(
              onPressed: () {
                // Aquí puedes implementar la lógica para el código QR
                Navigator.of(context).pop();
              },
              child: const Text('CÓDIGO QR'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _launchURL('https://speedsidetech.neocities.org/');
              },
              child: const Text('ENLACE WEB'),
            ),
          ],
        );
      },
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openMap(String location) async {
    String query = Uri.encodeComponent(location);
    String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Evento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (event.logoPath.isNotEmpty && File(event.logoPath).existsSync())
              Image.file(
                File(event.logoPath),
                height: 200,
                fit: BoxFit.cover,
              )
            else
              const PlaceholderImage(),
            const SizedBox(height: 16),
            Text(event.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(event.description),
            const SizedBox(height: 16),
            const Text('Requisitos necesarios', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('Todos los públicos'),
            const SizedBox(height: 16),
            const Text('Otras características', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(event.date),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(event.location),
              trailing: ElevatedButton(
                onPressed: () {
                  _openMap(event.location);
                },
                child: const Text('MAPA'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(event.duration),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text('${event.capacity} asistentes de aforo'),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: Text(event.eventType),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: Text('Precio: ${event.price}'),  // Mostrar el precio
            ),
            const SizedBox(height: 16),
            const Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                // Publicar en el escaparate
              },
              child: const Text('PUBLICAR EN EL ESCAPARATE'),
            ),
            ElevatedButton(
              onPressed: _showShareOptions,
              child: const Text('COMPARTIR'),
            ),
            ElevatedButton(
              onPressed: () {
                // Ver en web
              },
              child: const Text('VER EN WEB'),
            ),
            ElevatedButton(
              onPressed: () {
                // Añadir sesiones
              },
              child: const Text('AÑADIR SESIONES'),
            ),
            ElevatedButton(
              onPressed: () {
                // Diseño de entrada
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TicketDesignScreen()),
                );
              },
              child: const Text('DISEÑO DE ENTRADA'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventConfigScreen(
                      onCreateEvent: (updatedEvent) {
                        _updateEvent(updatedEvent as Event);
                      },
                      initialTitle: event.title,
                      initialDescription: event.description,
                      initialDate: event.date,
                      initialLocation: event.location,
                    ),
                  ),
                );
              },
              child: const Text('MODIFICAR'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageSessionScreen(event: event),
                  ),
                );
              },
              icon: const Icon(Icons.manage_accounts),
              label: const Text('GESTIONAR SESIÓN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 16),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.grey,
      child: const Center(
        child: Text(
          'No Image Available',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
