import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsWidget extends StatefulWidget {
  const MapsWidget({Key? key}) : super(key: key);

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);
  final Map<String, Marker> _markers = {};
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      Marker marker = Marker(
        markerId: MarkerId('id'),
        position: _center,
        infoWindow: InfoWindow(
          title: 'title',
          snippet: 'snippet',
        ),
      );
      _markers['id'] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
      markers: _markers.values.toSet(),
    );
  }
}
