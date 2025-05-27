import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bwb/chat_scree.dart';
import 'package:bwb/snackbar.dart';
import 'package:bwb/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  void addNearbyMarkers(LatLng currentLocation) {
    List<LatLng> nearbyPoints = [
      LatLng(
          currentLocation.latitude - 0.001, currentLocation.longitude - 0.001),
      LatLng(currentLocation.latitude - 0.01, currentLocation.longitude - 0.03),
      LatLng(currentLocation.latitude + 0.01, currentLocation.longitude + 0.03),
      LatLng(currentLocation.latitude - 0.01, currentLocation.longitude + 0.03),
      LatLng(currentLocation.latitude - 0.02, currentLocation.longitude + 0.06),
      LatLng(currentLocation.latitude + 0.06, currentLocation.longitude + 0.2),
      LatLng(currentLocation.latitude + 0.02, currentLocation.longitude + 0.7),
      LatLng(
          currentLocation.latitude - 0.006, currentLocation.longitude - 0.007),
      LatLng(
          currentLocation.latitude - 0.03, currentLocation.longitude - 0.009),
      LatLng(currentLocation.latitude - 0.09, currentLocation.longitude - 0.01),
      LatLng(currentLocation.latitude - 0.08, currentLocation.longitude - 0.07),
      LatLng(currentLocation.latitude - 0.03, currentLocation.longitude - 0.03),
    ];

    _markers.add(
      Marker(
        markerId: const MarkerId('marker_0'),
        position: currentLocation,
        icon: AssetMapBitmap('assets/user_location.png', width: 30, height: 30),
        infoWindow: const InfoWindow(title: 'Me'),
      ),
    );

    for (int i = 1; i < nearbyPoints.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: nearbyPoints[i],
          icon: AssetMapBitmap('assets/person_location.png',
              width: 30, height: 30),
          infoWindow: InfoWindow(title: 'user $i'),
        ),
      );
    }

    setState(() {});
  }

  Future<void> _animateToUser() async {
    await mapController.animateCamera(CameraUpdate.newLatLng(userLatLng!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
              addNearbyMarkers(userLatLng!);
              _animateToUser();
            },
            initialCameraPosition: CameraPosition(
              target: userLatLng ?? const LatLng(37.385002, -122.1066913),
              zoom: 11.0,
            ),
            markers: Set<Marker>.of(_markers),
            style: 'assets/map_styles/dark_map.json',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.all(20),
                        content: SizedBox(
                          width: double.maxFinite / 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedTextKit(
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      'Finding Buddy that matches your vibe',
                                      textStyle: TextStyle(
                                        color: Colors.deepPurple.shade700,
                                        fontSize: 20,
                                      ),
                                      speed: const Duration(milliseconds: 50),
                                    ),
                                  ]),
                              const CupertinoActivityIndicator(
                                radius: 12,
                                color: Colors.deepPurple,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  Future.delayed(const Duration(seconds: 4), () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ),
                    );
                  });
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 80),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text(
                      'Find Buddy',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LocationExample extends StatefulWidget {
  const LocationExample({super.key});

  @override
  _LocationExampleState createState() => _LocationExampleState();
}

class _LocationExampleState extends State<LocationExample> {
  String locationMessage = "Location not fetched";

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied.");
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      locationMessage = "Lat: ${position.latitude}, Lon: ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Current Location")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locationMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getCurrentLocation,
              child: const Text("Get Location"),
            ),
          ],
        ),
      ),
    );
  }
}
