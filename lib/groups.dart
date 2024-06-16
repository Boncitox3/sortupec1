import 'package:flutter/material.dart';
import 'screens/create_group.dart';
import 'screens/perfil.dart';
import 'screens/sorteos.dart';
import 'screens/regalos.dart';
import 'screens/config.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  GroupsState createState() => GroupsState(); // Uso de la clase pública GroupsState
}

class GroupsState extends State<Groups> { // Clase pública GroupsState
  int _currentIndex = 0;
  final List<Widget> _children = const [
    PerfilScreen(),
    SorteoScreen(),
    RegalosScreen(),
    ConfigScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizadores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Agrega tu lógica para el menú aquí
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Sorteos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Regalos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Config',
          ),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateGroup()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
