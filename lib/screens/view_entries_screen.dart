import 'package:flutter/material.dart';
import '../models/event.dart';

class ViewEntriesScreen extends StatelessWidget {
  final Event event;

  const ViewEntriesScreen({required this.event, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hola'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'SESIÓN'),
              Tab(text: 'ENTRADAS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSessionTab(context),
            _buildEntriesTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SESIÓN', style: Theme.of(context).textTheme.titleLarge),
          Text(event.date, style: Theme.of(context).textTheme.titleMedium), // Corrección aquí
          const SizedBox(height: 10),
          Text('Tipos de entrada', style: Theme.of(context).textTheme.titleMedium),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: Text(event.eventType),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sin limite', style: TextStyle(color: Colors.orange)),
                  Text('\$${event.currency}', style: const TextStyle(color: Colors.green)),
                ],
              ),
              trailing: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('0', style: TextStyle(color: Colors.blue)),
                  Text('Sin multi accesos'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Acciones', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildActionButton(context, Icons.list, 'VER PEDIDOS'),
              _buildActionButton(context, Icons.edit, 'MODIFICAR'),
              _buildActionButton(context, Icons.qr_code, 'VALIDAR'),
              _buildActionButton(context, Icons.sell, 'VENDER'),
              _buildActionButton(context, Icons.announcement, 'COMUNICADO'),
              _buildActionButton(context, Icons.cancel, 'CANCELAR', color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ENTRADAS', style: Theme.of(context).textTheme.titleLarge),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: Text(event.eventType),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1/150', style: TextStyle(color: Colors.blue)),
                  Text('\$${event.currency}', style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Acciones', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildActionButton(context, Icons.file_download, 'EXPORTAR A EXCEL', color: Colors.green),
              _buildActionButton(context, Icons.web, 'GENERAR TALONARIO', color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext? context, IconData icon, String label, {Color color = Colors.blue}) {
    return ElevatedButton.icon(
      onPressed: () {
        if (context != null) {
          Navigator.pop(context);
        }
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(150, 50),
      ),
    );
  }
}
