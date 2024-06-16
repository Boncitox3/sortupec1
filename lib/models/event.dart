class Event {
  final String title;
  final String description;
  final String date;
  final String time;
  final String duration;
  final String capacity;
  final String location;
  final String logoPath;
  final String eventType;
  final String currency;
  final String price;  // Añadir el campo de precio

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.duration,
    required this.capacity,
    required this.location,
    required this.logoPath,
    required this.eventType,
    required this.currency,
    required this.price,  // Inicializar el campo de precio
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'duration': duration,
      'capacity': capacity,
      'location': location,
      'logoPath': logoPath,
      'eventType': eventType,
      'currency': currency,
      'price': price,  // Añadir el campo de precio al mapa
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'],
      description: map['description'],
      date: map['date'],
      time: map['time'],
      duration: map['duration'],
      capacity: map['capacity'],
      location: map['location'],
      logoPath: map['logoPath'],
      eventType: map['eventType'],
      currency: map['currency'],
      price: map['price'],  // Obtener el campo de precio del mapa
    );
  }
}
