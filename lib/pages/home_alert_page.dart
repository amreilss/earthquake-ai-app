/// ✅ home_alert_page.dart (แก้ให้รองรับ JSON โครงสร้างใหม่)
/// รองรับ field: magnitude, depth, reaction, intensity, destructionNumber, location.lat/lng

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlertNotification {
  final String date;
  final String area;
  final String magnitude;
  final String depth;
  final String reaction;
  final String destruction;
  final String intensity;
  final double lat;
  final double lng;

  AlertNotification({
    required this.date,
    required this.area,
    required this.magnitude,
    required this.depth,
    required this.reaction,
    required this.destruction,
    required this.intensity,
    required this.lat,
    required this.lng,
  });

  factory AlertNotification.fromJson(Map<String, dynamic> json) {
    final location = json['location'] ?? {};
    final lat = location['lat'] ?? location['_latitude'] ?? 0.0;
    final lng = location['lng'] ?? location['_longitude'] ?? 0.0;

    DateTime date;
    if (json.containsKey('createDate') &&
        json['createDate'] is Map &&
        json['createDate']['_seconds'] != null) {
      final timestamp = json['createDate']['_seconds'];
      date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    } else {
      date = DateTime.now();
    }

    final magnitude = json['magnitude']?.toString() ?? "null";
    final depth = json['depth']?.toString() ?? "null";

    return AlertNotification(
      date: date.toString(),
      area: '',
      magnitude: magnitude,
      depth: depth,
      reaction: json['reaction'] ?? '',
      destruction: json['destructionNumber']?.toString() ?? getDestructionFromMagnitude(magnitude),
      intensity: json['intensity']?.toString() ?? getIntensityFromMagnitude(magnitude),
      lat: double.tryParse(lat.toString()) ?? 0.0,
      lng: double.tryParse(lng.toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    "date": date,
    "area": area,
    "magnitude": magnitude,
    "depth": depth,
    "reaction": reaction,
    "destruction": destruction,
    "intensity": intensity,
    "lat": lat,
    "lng": lng,
  };
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

  void _initFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
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
      }
    });
  }

  @override
  void initState() {

    super.initState();
    _getCurrentLocation();
    _loadLocalHistory(); // ✅ เพิ่มบรรทัดนี้
    _initFirebaseMessaging(); // ✅ ใช้รับ fcm ตอนเปิดแอป

    channel = WebSocketChannel.connect(
      Uri.parse('ws://api.earthquakeai.site/ws/'),
    );

    channel.stream.listen((message) async {
      try {
        final data = jsonDecode(message);
        final alert = AlertNotification.fromJson(data);

        String areaName = 'Unknown';
        try {
          final placemark = await placemarkFromCoordinates(alert.lat, alert.lng);
          if (placemark.isNotEmpty) {
            areaName = '${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].country}';
          }
        } catch (_) {}

        final enrichedAlert = AlertNotification(
          date: alert.date,
          area: areaName,
          magnitude: alert.magnitude,
          depth: alert.depth,
          reaction: alert.reaction,
          destruction: alert.destruction,
          intensity: alert.intensity,
          lat: alert.lat,
          lng: alert.lng,
        );

        setState(() {
          alertHistory.insert(0, enrichedAlert);
        });
        _saveAlertHistory(); // ✅ เพิ่มบรรทัดนี้

        if (currentPosition != null && isWithinAlertRadius(enrichedAlert, currentPosition!)) {
          // Popup
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

          // Local Notification
          flutterLocalNotificationsPlugin.show(
            enrichedAlert.hashCode,
            '🌍 Earthquake Alert',
            'Magnitude ${enrichedAlert.magnitude} at ${enrichedAlert.area}',
            const NotificationDetails(
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
        }
      } catch (_) {}
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

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
        '${place.name}, ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
      });
    }
  }

  Future<void> _loadLocalHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('alertHistory') ?? [];

    setState(() {
      alertHistory = saved.map((e) {
        final Map<String, dynamic> json = jsonDecode(e);
        return AlertNotification.fromJson(json);
      }).toList();
    });
  }

  Future<void> _saveAlertHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = alertHistory.map((e) => jsonEncode({
      "date": e.date,
      "area": e.area,
      "magnitude": e.magnitude,
      "depth": e.depth,
      "reaction": e.reaction,
      "destruction": e.destruction,
      "intensity": e.intensity,
      "lat": e.lat,
      "lng": e.lng,
    })).toList();
    await prefs.setStringList('alertHistory', saved);
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
    return dist <= allowedRadius;
  }

  Widget _buildNotificationList() {
    if (alertHistory.isEmpty) {
      return const Center(
        child: Text(
          "ไม่มีข้อมูลแจ้งเตือน",
          style: TextStyle(
            fontFamily: 'InriaSerif',
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      children: alertHistory.map((data) {
        // ข้ามการแสดงถ้าข้อมูลไม่สมบูรณ์
        if (data.magnitude == "null" || data.depth == "null") {
          return const SizedBox.shrink();
        }

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
              Text('Depth : ${data.depth}'),
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
