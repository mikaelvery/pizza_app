// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// class DeliveryMap extends StatefulWidget {
//   final LatLng pizzeriaLocation;
//   final LatLng deliveryLocation;

//   const DeliveryMap({super.key, required this.pizzeriaLocation, required this.deliveryLocation});

//   @override
//   DeliveryMapState createState() => DeliveryMapState();
// }

// class DeliveryMapState extends State<DeliveryMap> {
//   late GoogleMapController mapController;
//   late PolylinePoints polylinePoints;
//   List<LatLng> polylineCoordinates = [];
//   List<LatLng> traveledPolylineCoordinates = [];
//   int currentStep = 0;

//   @override
//   void initState() {
//     super.initState();
//     polylinePoints = PolylinePoints();
//     _getPolylineCoordinates();
//     _startDeliveryAnimation();
//   }

//   Future<void> _getPolylineCoordinates() async {
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       'AIzaSyBJewi9S3ybL9R4oTS4cHTph1TtZCVkhkgCf12UCmHTL3Uv_u-AM71y_ckPjXQMVIUU',
//       PointLatLng(widget.pizzeriaLocation.latitude, widget.pizzeriaLocation.longitude),
//       PointLatLng(widget.deliveryLocation.latitude, widget.deliveryLocation.longitude),
//     );

//     if (result.points.isNotEmpty) {
//       if (kDebugMode) {
//         print('Polyline coordinates: ${result.points}');
//       }
//       setState(() {
//         polylineCoordinates = result.points.map((point) => LatLng(point.latitude, point.longitude)).toList();
//         traveledPolylineCoordinates.add(polylineCoordinates.first); 
//       });
//     }
//   }

//   void _startDeliveryAnimation() {
//     // Vitesse de livraison E=MC2 
//     Timer.periodic(const Duration(seconds: 2), (timer) {
//       if (kDebugMode) {
//         print('Current step: $currentStep');
//       }
//       if (currentStep < polylineCoordinates.length) {
//         setState(() {
//           currentStep++;
//           traveledPolylineCoordinates.add(_getDeliveryPosition()); // Ajoute les coordonnées au chemin parcouru
//           mapController.animateCamera(CameraUpdate.newLatLng(_getDeliveryPosition())); // Centre la caméra sur la position du livreur
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       initialCameraPosition: CameraPosition(
//         target: widget.pizzeriaLocation,
//         zoom: 12.0,
//       ),
//       markers: {
//         Marker(
//           markerId: const MarkerId('pizzeria'),
//           position: widget.pizzeriaLocation,
//           infoWindow: const InfoWindow(title: 'Ciao Ciao'),
//         ),
//         Marker(
//           markerId: const MarkerId('Mobylette'),
//           position: _getDeliveryPosition(),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           infoWindow: const InfoWindow(title: 'Danny est en route'),
//         ),
//         Marker(
//           markerId: const MarkerId('delivery'),
//           position: widget.deliveryLocation,
//           infoWindow: const InfoWindow(title: 'Adresse de livraison'),
//         ),
//       },
//       polylines: {
//         Polyline(
//           polylineId: const PolylineId('deliveryRoute'),
//           points: polylineCoordinates.sublist(0, currentStep),
//           color: Colors.blue,
//           width: 5,
//         ),
//         Polyline(
//           polylineId: const PolylineId('traveledRoute'),
//           points: traveledPolylineCoordinates,
//           color: Colors.green,
//           width: 5,
//         ),
//       },
//       onMapCreated: (GoogleMapController controller) {
//         setState(() {
//           mapController = controller;
//         });
//       },
//     );
//   }

//   LatLng _getDeliveryPosition() {
//     if (currentStep < polylineCoordinates.length) {
//       return polylineCoordinates[currentStep];
//     } else {
//       return widget.deliveryLocation;
//     }
//   }
// }
