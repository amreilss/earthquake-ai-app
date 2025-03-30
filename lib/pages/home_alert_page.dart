import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/alert_notification.dart';

class HomeAlertPage extends StatefulWidget {
  const HomeAlertPage({Key? key}) : super(key: key);

  @override
  State<HomeAlertPage> createState() => _HomeAlertPageState();
}

class _HomeAlertPageState extends State<HomeAlertPage> {
  final MapController _mapController = MapController();
  LatLng? currentPosition;
  String currentAddress = 'Loading address...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // ดึงตำแหน่งตอนเปิดแอป
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _updatePosition(LatLng(position.latitude, position.longitude));
  }

  Future<void> _updatePosition(LatLng position) async {
    setState(() {
      currentPosition = position;
    });
    _mapController.move(position, 15.0);

    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
        '${place.name}, ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
      });
    }
  }

  Future<AlertNotification?> fetchNotification() async {
    final response = await http.get(
      Uri.parse('https://jsonkeeper.com/b/0F5H'), // ← เปลี่ยน URL เป็นของคุณ
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AlertNotification.fromJson(data);
    } else {
      throw Exception('Failed to load notification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        title: const Text(
          'Alert',
          style: TextStyle(
            fontFamily: 'InriaSerif',
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 60,
              height: 60,
            ),
          )
        ],
      ),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your area',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'InriaSerif'),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(currentAddress),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('อัปเดตตำแหน่ง'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade300,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: currentPosition,
                  zoom: 13.0,
                  onTap: (tapPosition, point) {
                    _updatePosition(point);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80,
                        height: 80,
                        point: currentPosition!,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Notification',
                style: TextStyle(
                  fontFamily: 'InriaSerif',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<AlertNotification?>(
              future: fetchNotification(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('No notification found');
                }

                final data = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date : ${data.date}'),
                      const SizedBox(height: 4),
                      Text('Area : ${data.area}'),
                      const SizedBox(height: 8),
                      Text('Magnitude : ${data.magnitude}'),
                      Text('Dept : ${data.dept}'),
                      Text('Reaction : ${data.reaction}'),
                      Text('Destruction : ${data.destruction}'),
                      Text('Intensity : ${data.intensity}'),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
