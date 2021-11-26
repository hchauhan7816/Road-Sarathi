import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';
import 'package:sadak/Pages/Slider/Widgets/constants.dart';
import 'package:sadak/Pages/Map%20Page/map_page.dart';

class Temp extends StatefulWidget {
  const Temp({Key? key}) : super(key: key);

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> with SingleTickerProviderStateMixin {
  double? latitude, longitude;
  bool locationRecieved = false;
  bool changeButton = false;
  bool isLoading = false;
  AnimationController? rotationController;

  LatLng? position;

  setLocation({required lat, required lon}) {
    latitude = lat;
    longitude = lon;
    setState(() {
      position = LatLng(lat, lon);
      locationRecieved = true;
    });
  }

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        upperBound: 3.14 * 2);
  }

  void getUserLocation() async {
    setState(() {
      isLoading = true;
    });

    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location Service Disabled');
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("permissions not given");
      LocationPermission asked = await Geolocator.requestPermission();

      if (asked == LocationPermission.whileInUse ||
          asked == LocationPermission.always) {
        Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);

        setLocation(
            lat: currentPosition.latitude, lon: currentPosition.longitude);
      }
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      setLocation(
          lat: currentPosition.latitude, lon: currentPosition.longitude);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enter Location"),
              Text("Latitude  -> $latitude"),
              Text("Longitude  -> $longitude"),
              SizedBox(
                height: 10,
              ),
              // FlatButton(
              //   onPressed: () {
              //     getUserLocation();
              //   },
              //   color: Colors.redAccent,
              //   child: Text("Provide Location"),
              // ),
              // SizedBox(
              //   height: 400,
              //   width: 300,

              // )

              Material(
                color: Colors.orange[300],
                borderRadius: BorderRadius.circular(changeButton ? 50 : 8),
                child: InkWell(
                  onTap: () {
                    getUserLocation();
                    changeButton = true;
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: changeButton ? 50 : 150,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(changeButton ? 50 : 8),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.black54,
                          )
                        : changeButton
                            ? Icon(Icons.refresh)
                            : Text("Provide Location"),
                  ),
                ),
              ),

              FlatButton(
                onPressed: () {
                  if (locationRecieved)
                    Get.to(ShowMap(position: position!));
                  else
                    Get.snackbar("Error!", "Please enter the location first");
                },
                color: Colors.redAccent,
                child: Text("Go to map"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
