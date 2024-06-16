import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/organizer_provider.dart';
import 'providers/event_provider.dart'; // Importar EventProvider
import 'wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrganizerProvider()),
        Provider(create: (_) => EventProvider()), // Añadir EventProvider
      ],
      child: MaterialApp(
        title: 'Google Login Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Wrapper(), // Iniciar en el Wrapper
      ),
    );
  }
}
