import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/foundation.dart';

class PizzeriaMap extends StatefulWidget {
  final User? user;
  final LatLng? deliveryLocation;

  const PizzeriaMap({super.key, required this.user, this.deliveryLocation});

  @override
  PizzeriaMapState createState() => PizzeriaMapState();
}

class PizzeriaMapState extends State<PizzeriaMap> {
  late GoogleMapController mapController;
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var location = Location();
    try {
      LocationData currentLocation = await location.getLocation();
      setState(() {
        this.currentLocation = currentLocation;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const LatLng pizzeriaPosition = LatLng(43.659319, 3.912129);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizzeria Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation != null
              ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
              : pizzeriaPosition,
          zoom: 15.0,
        ),
        markers: _buildMarkers(),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {
      const Marker(
        markerId: MarkerId('pizzeria'),
        position: LatLng(43.659152, 3.912033),
        infoWindow: InfoWindow(title: 'Ciao Ciao'),
      ),
    };

    if (widget.deliveryLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('delivery'),
          position: widget.deliveryLocation!,
          infoWindow: const InfoWindow(title: 'Livraison en cours'),
        ),
      );
    }
    return markers;
  }
}

