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

  // ✅ แก้ให้รองรับ JSON รูปแบบใหม่
  factory AlertNotification.fromJson(Map<String, dynamic> json) {
    final magnitude = json['magnitude'].toString();
    final depth = json['depth'].toString();

    return AlertNotification(
      date: DateTime.now().toString(),
      area: 'Unknown area', // คุณอาจใช้ reverse geocoding ได้ภายหลัง
      magnitude: magnitude,
      depth: depth,
      reaction: json['reaction'] ?? '',
      destruction: json['destructionNumber']?.toString() ?? getDestructionFromMagnitude(magnitude),
      intensity: json['intensity']?.toString() ?? getIntensityFromMagnitude(magnitude),
      lat: double.tryParse(json['location']?['lat'].toString() ?? '') ?? 0.0,
      lng: double.tryParse(json['location']?['lng'].toString() ?? '') ?? 0.0,
    );
  }
}

// ✅ ฟังก์ชันสำรองหากไม่มี intensity หรือ destruction จาก JSON
String getDestructionFromMagnitude(String magStr) {
  final mag = double.tryParse(magStr) ?? 0.0;
  if (mag < 4.0) return "No damage";
  if (mag < 5.0) return "Minor";
  if (mag < 6.0) return "Moderate";
  if (mag < 7.0) return "Major";
  return "Severe";
}

String getIntensityFromMagnitude(String magStr) {
  final mag = double.tryParse(magStr) ?? 0.0;
  if (mag < 4.0) return "Weak";
  if (mag < 5.0) return "Light";
  if (mag < 6.0) return "Moderate";
  if (mag < 7.0) return "Strong";
  return "Violent";
}
