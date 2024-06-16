import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import 'event_config.dart';
import 'event_details.dart';
import 'dart:io';

class SorteoEvent extends Event {
  SorteoEvent({
    required String title,
    required String description,
    required String date,
    required String time,
    required String duration,
    required String capacity,
    required String location,
    required String logoPath,
    required String eventType,
    required String currency,
    required String price,
  }) : super(
          title: title,
          description: description,
          date: date,
          time: time,
          duration: duration,
          capacity: capacity,
          location: location,
          logoPath: logoPath,
          eventType: eventType,
          currency: currency,
          price: price,
        );
}

class SorteoScreen extends StatefulWidget {
  const SorteoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SorteoScreenState createState() => _SorteoScreenState();
}

class _SorteoScreenState extends State<SorteoScreen> {
  void _addEvent(Event event) {
    setState(() {
      // Implementa la lógica para añadir el evento aquí
    });
  }

  void _updateEvent(Event event) {
    setState(() {
      // Implementa la lógica para actualizar el evento aquí
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sorteos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ACTIVOS'),
              Tab(text: 'FINALIZADOS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildActivosTab(context),
            _buildFinalizadosTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivosTab(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventConfigScreen(
                    onCreateEvent: (event) => _addEvent(event),
                    initialTitle: '',
                    initialDescription: '',
                    initialDate: '',
                    initialLocation: '',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 50),
            ),
            child: const Text('+ CREAR UN EVENTO'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<Event>>(
              stream: Provider.of<EventProvider>(context).getEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading events');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Column(
                    children: [
                      Icon(Icons.info, size: 50, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        'No hay eventos pendientes para este organizador',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                } else {
                  final events = snapshot.data!;
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        leading: event.logoPath.isNotEmpty && File(event.logoPath).existsSync()
                            ? Image.file(File(event.logoPath), width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.event),
                        title: Text(event.title),
                        subtitle: Text(event.description),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailsScreen(
                                event: event,
                                onUpdateEvent: _updateEvent,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalizadosTab() {
    return const Center(
      child: Text('No hay eventos finalizados'),
    );
  }
}
