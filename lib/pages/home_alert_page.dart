import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class AlertNotification {
  final String date;
  final String area;
  final String magnitude;
  final String dept;
  final String reaction;
  final String destruction;
  final String intensity;
  final double lat;
  final double lng;

  AlertNotification({
    required this.date,
    required this.area,
    required this.magnitude,
    required this.dept,
    required this.reaction,
    required this.destruction,
    required this.intensity,
    required this.lat,
    required this.lng,
  });

  factory AlertNotification.fromJson(Map<String, dynamic> json) {
    final location = json['location'] ?? {};
    final lat = location['_latitude'] ?? location['lat'] ?? 0.0;
    final lng = location['_longitude'] ?? location['lng'] ?? 0.0;

    DateTime date;
    if (json.containsKey('createDate') &&
        json['createDate'] is Map &&
        json['createDate']['_seconds'] != null) {
      final timestamp = json['createDate']['_seconds'];
      date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    } else {
      date = DateTime.now(); // ถ้าไม่มี timestamp มา
    }

    final magnitude = json['magnitude'].toString();

    return AlertNotification(
      date: date.toString(),
      area: '',
      magnitude: magnitude,
      dept: json['depth'].toString(),
      reaction: json['reaction'] ?? '',
      destruction: getDestructionFromMagnitude(magnitude),
      intensity: getIntensityFromMagnitude(magnitude),
      lat: double.tryParse(lat.toString()) ?? 0.0,
      lng: double.tryParse(lng.toString()) ?? 0.0,
    );
  }
}

String getDestructionFromMagnitude(String magStr) {
  final mag = double.tryParse(magStr) ?? 0.0;
  if (mag < 4.0) return "No damage ไม่มีผลกระทบ";
  if (mag < 5.0) return "Minor ขนาดเล็ก";
  if (mag < 6.0) return "Moderate ขนาดปานกลาง";
  if (mag < 7.0) return "Major ขนาดใหญ่";
  return "Severe ขนาดรุนแรง!";
}

String getIntensityFromMagnitude(String magStr) {
  final mag = double.tryParse(magStr) ?? 0.0;
  if (mag < 4.0) return "Weak ไม่ส่งผลกระทบ";
  if (mag < 5.0) return "Light ผลกระทบเล็กน้อย";
  if (mag < 6.0) return "Moderate ผลกระทบปานกลาง";
  if (mag < 7.0) return "Strong ผลกระทบมาก";
  return "Violent ผลกระทบรุนแรง!";
}

class HomeAlertPage extends StatefulWidget {
  const HomeAlertPage({Key? key}) : super(key: key);

  @override
  State<HomeAlertPage> createState() => _HomeAlertPageState();
}

class _HomeAlertPageState extends State<HomeAlertPage> {
  final MapController _mapController = MapController();
  LatLng? currentPosition;
  String currentAddress = 'Loading address...';

  late WebSocketChannel channel;
  List<AlertNotification> alertHistory = [];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    channel = WebSocketChannel.connect(
      Uri.parse('ws://api.earthquakeai.site/ws/'),
    );

    channel.stream.listen((message) async {
      print('📡 ได้ข้อมูลจาก WebSocket: $message');
      try {
        final data = jsonDecode(message);
        final alert = AlertNotification.fromJson(data);
        print('📥 แปลง JSON แล้ว: ${alert.magnitude}, ${alert.lat}, ${alert.lng}');

        String areaName = 'Unknown';
        try {
          final placemark = await placemarkFromCoordinates(alert.lat, alert.lng);
          if (placemark.isNotEmpty) {
            areaName = '${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].country}';
          }
        } catch (e) {
          print('⚠️ placemark error: $e');
        }

        final enrichedAlert = AlertNotification(
          date: alert.date,
          area: areaName,
          magnitude: alert.magnitude,
          dept: alert.dept,
          reaction: alert.reaction,
          destruction: alert.destruction,
          intensity: alert.intensity,
          lat: alert.lat,
          lng: alert.lng,
        );

        setState(() {
          alertHistory.insert(0, enrichedAlert);
          print('📍 Added to history: ${enrichedAlert.magnitude}');
        });

        if (currentPosition != null && isWithinAlertRadius(enrichedAlert, currentPosition!)) {
          // 🔔 Popup
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("🌐 Earthquake Alert"),
              content: Text(
                "Magnitude ${enrichedAlert.magnitude}\nLocation: ${enrichedAlert.area}\nReaction: ${enrichedAlert.reaction}",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                )
              ],
            ),
          );

          // 🔔 Local Notification
          flutterLocalNotificationsPlugin.show(
            enrichedAlert.hashCode,
            '🌍 Earthquake Alert',
            'Magnitude ${enrichedAlert.magnitude} at ${enrichedAlert.area}',
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription: 'Used for important notifications',
                importance: Importance.max,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        } else {
          print('📍 แผ่นดินไหวอยู่นอกระยะที่ควรแจ้งเตือน');
        }
      } catch (e) {
        print('❗ JSON ผิดพลาด: $e');
      }
    });
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

  double getAlertRadius(String magnitudeStr) {
    final mag = double.tryParse(magnitudeStr) ?? 0.0;
    if (mag < 4.0) return 0;
    if (mag < 5.0) return 50 * 1000;
    if (mag < 6.0) return 100 * 1000;
    if (mag < 7.0) return 200 * 1000;
    return 400 * 1000;
  }

  bool isWithinAlertRadius(AlertNotification alert, LatLng userPos) {
    final Distance distance = Distance();
    final double dist = distance.as(
      LengthUnit.Meter,
      LatLng(alert.lat, alert.lng),
      userPos,
    );
    final double allowedRadius = getAlertRadius(alert.magnitude);
    print('🔍 ห่างจาก epicenter: ${dist.toStringAsFixed(2)} m, ขีดจำกัด: $allowedRadius m');
    return dist <= allowedRadius;
  }

  Widget _buildNotificationList() {
    if (alertHistory.isEmpty) {
      return const Text("ไม่มีข้อมูลแจ้งเตือน");
    }

    return Column(
      children: alertHistory.map((data) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date : ${data.date}'),
              Text('Area : ${data.area}'),
              Text('Magnitude : ${data.magnitude}'),
              Text('Dept : ${data.dept}'),
              Text('Reaction : ${data.reaction}'),
              Text('Destruction : ${data.destruction}'),
              Text('Intensity : ${data.intensity}'),
            ],
          ),
        );
      }).toList(),
    );
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
            _buildNotificationList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
