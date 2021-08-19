import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Restaurant Screen
class RestaurantLocationScreen extends StatefulWidget {
  final String restaurantName;
  final GeoPoint geoPoint;

  RestaurantLocationScreen(
      {@required this.restaurantName, @required this.geoPoint});

  @override
  _RestaurantLocationScreenState createState() =>
      _RestaurantLocationScreenState();
}

class _RestaurantLocationScreenState extends State<RestaurantLocationScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static LatLng _currentLoc;
  final Set<Marker> listMarkers = {};

  @override
  void initState() {
    super.initState();

    // Set current location
    GeoPoint geoPoint = widget.geoPoint;
    _currentLoc = LatLng(geoPoint.latitude, geoPoint.longitude);

    // Set marker
    setState(() {
      listMarkers.add(
        Marker(
          markerId: MarkerId("1"),
          position: _currentLoc,
          infoWindow: InfoWindow(title: "Restaurant Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(0),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: Text(
          widget.restaurantName,
        ),
      ),
      // End of App Bar
      // Body
      body: GoogleMap(
        markers: Set.from(listMarkers),
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentLoc,
          zoom: 16.0,
        ),
      ),
      // End of Body
    );
  }
}
// End of Restaurant Screen
