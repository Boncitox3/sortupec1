import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sortupec/login.dart'; // Asegúrate de que esta sea la ruta correcta a tu archivo login.dart

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  void _launchURL() async {
    const url = 'https://speedsidetech.neocities.org/';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opciones'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const ListTile(
            title: Text('Cuenta', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('Editar cuenta'),
            onTap: () {
              // Lógica para editar cuenta
            },
          ),
          ListTile(
            title: const Text('Suscripciones'),
            onTap: () {
              // Lógica para suscripciones
            },
          ),
          ListTile(
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _signOut(context),
          ),
          const Divider(),
          const ListTile(
            title: Text('Notificaciones', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            title: const Text('Activar notificaciones'),
            value: true,
            onChanged: (bool value) {
              // Lógica para activar/desactivar notificaciones
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Necesito ayuda', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('Preguntas frecuentes'),
            onTap: () {
              // Lógica para preguntas frecuentes
            },
          ),
          ListTile(
            title: const Text('Ver video guías'),
            onTap: () {
              // Lógica para ver video guías
            },
          ),
          ListTile(
            title: const Text('Nuestro Instagram'),
            onTap: () {
              // Lógica para Instagram
            },
          ),
          ListTile(
            title: const Text('Contactar con nosotros'),
            onTap: () {
              // Lógica para contactar
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('App', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('Ir a la web'),
            onTap: _launchURL,
          ),
        ],
      ),
    );
  }
}
