import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sadak/Pages/Slider/Widgets/constants.dart';

// ignore: must_be_immutable
class ShowMap extends StatefulWidget {
  ShowMap({Key? key, required this.position}) : super(key: key);
  LatLng position;

  @override
  _ShowMapState createState() => _ShowMapState();
}

Completer<GoogleMapController> _controller = Completer();

class _ShowMapState extends State<ShowMap> {
  static LatLng? _intialLatLang;
  static CameraPosition? _initialPosition;

  Set<Marker> mapMarkers = {};

  @override
  void initState() {
    super.initState();
    _intialLatLang = widget.position;
    _initialPosition = CameraPosition(target: _intialLatLang!, zoom: 13);

    Marker _initialMarker = Marker(
      markerId: MarkerId(_initialPosition.toString()),
      position: _intialLatLang!,
      infoWindow: const InfoWindow(
        title: 'Bad Road Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    mapMarkers.add(_initialMarker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: GoogleMap(
        markers: mapMarkers,
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition!,
        onMapCreated: (GoogleMapController controller) {
          if (!_controller.isCompleted) _controller.complete(controller);
        },
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kActiveIconColor,
        foregroundColor: Colors.black87,
        onPressed: _goToHome,
        child: const Icon(Icons.location_on_outlined),
      ),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: kActiveIconColor,
      title: const Text(
        'Google Maps',
        style: TextStyle(fontSize: 24, height: 1.2),
      ),
    );
  }

  Future<void> _goToHome() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition!));
  }
}
