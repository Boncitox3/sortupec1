import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

const kGoogleApiKey = "AIzaSyCbcGRkzBSvNmINyREtpzHw-tIo7we_02A";

class LocationScreen extends StatefulWidget {
  final TextEditingController locationController;

  const LocationScreen({Key? key, required this.locationController}) : super(key: key);

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  GoogleMapController? mapController;
  final LatLng initialPosition = const LatLng(-0.180653, -78.467834);
  LatLng selectedPosition = const LatLng(-0.180653, -78.467834);

  @override
  void initState() {
    super.initState();
    if (widget.locationController.text.isNotEmpty) {
      final coordinates = widget.locationController.text.split(',');
      if (coordinates.length == 2) {
        selectedPosition = LatLng(
          double.parse(coordinates[0].trim()),
          double.parse(coordinates[1].trim()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubicación',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: widget.locationController,
              decoration: InputDecoration(
                labelText: 'Escribe una dirección',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.map),
            label: const Text('BUSCAR UBICACIÓN'),
            onPressed: _navigateToMap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedPosition,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              onTap: _handleTap,
              markers: {
                Marker(
                  markerId: const MarkerId('selected-location'),
                  position: selectedPosition,
                ),
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  widget.locationController.clear();
                  setState(() {
                    selectedPosition = initialPosition;
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade800,
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('LIMPIAR'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('ACEPTAR'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToMap() async {
    final LatLng? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapScreen(initialPosition: selectedPosition),
      ),
    );

    if (result != null) {
      setState(() {
        selectedPosition = result;
        _reverseGeocode(selectedPosition);
      });
    }
  }

  void _handleTap(LatLng point) {
    setState(() {
      selectedPosition = point;
      _reverseGeocode(selectedPosition);
    });
  }

  void _reverseGeocode(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        widget.locationController.text = "${place.name}, ${place.locality}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        widget.locationController.text = "${position.latitude}, ${position.longitude}";
      });
    }
  }
}

class MapScreen extends StatefulWidget {
  final LatLng initialPosition;

  const MapScreen({Key? key, required this.initialPosition}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng selectedPosition = const LatLng(-0.180653, -78.467834);

  @override
  void initState() {
    super.initState();
    selectedPosition = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seleccionar Ubicación',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop(selectedPosition);
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: selectedPosition,
          zoom: 14,
        ),
        onMapCreated: (controller) {
          mapController = controller;
          mapController.animateCamera(
            CameraUpdate.newLatLng(selectedPosition),
          );
        },
        onTap: _handleTap,
        markers: {
          Marker(
            markerId: const MarkerId('selected-location'),
            position: selectedPosition,
          ),
        },
      ),
    );
  }

  void _handleTap(LatLng point) {
    setState(() {
      selectedPosition = point;
      mapController.animateCamera(
        CameraUpdate.newLatLng(point),
      );
    });
  }
}
