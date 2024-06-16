import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEvent(Event event) async {
    await _firestore.collection('events').add(event.toMap());
  }

  Stream<List<Event>> getEvents() {
    return _firestore.collection('events').snapshots().map((snapshot) {
      // ignore: unnecessary_cast
      return snapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }
}
