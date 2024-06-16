import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/organizer.dart';
import 'package:logger/logger.dart';

class OrganizerProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  List<Organizer> _organizers = [];

  List<Organizer> get organizers => _organizers;

  Future<void> addOrganizer(Organizer organizer) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('organizer_groups').add({
        'userId': userId,
        'name': organizer.name,
        'bio': organizer.bio,
        'logoPath': organizer.logoPath,
        'email': organizer.email,
        'phone': organizer.phone,
        'createdAt': Timestamp.now(),
      }).then((value) {
        _logger.i("Organizer Added: ${value.id}");
      }).catchError((error) {
        _logger.e("Failed to add organizer: $error");
      });
      _organizers.add(organizer);
      notifyListeners();
    }
  }

  Future<void> fetchOrganizers() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('organizer_groups')
          .where('userId', isEqualTo: userId)
          .get();

      _organizers = snapshot.docs.map((doc) {
        return Organizer(
          name: doc['name'],
          bio: doc['bio'],
          logoPath: doc['logoPath'],
          email: doc['email'],
          phone: doc['phone'],
        );
      }).toList();

      notifyListeners();
    }
  }
}
