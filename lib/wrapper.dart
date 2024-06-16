import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Importa foundation.dart para usar kDebugMode
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (kDebugMode) {
            debugPrint("User is logged in");
          }
          return const HomePage(); // Asegúrate de que el nombre de la clase sea correcto
        } else {
          if (kDebugMode) {
            debugPrint("User is not logged in");
          }
          return const Login();
        }
      },
    );
  }
}
