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

  // ✅ ฟังก์ชันสร้าง object จาก JSON (ใช้ใน WebSocket)
  factory AlertNotification.fromJson(Map<String, dynamic> json) {
    final magnitude = json['magnitude'].toString();
    return AlertNotification(
      date: DateTime.now().toString(),
      area: 'Unknown area', // หรือใส่ location จาก json ถ้ามี
      magnitude: magnitude,
      dept: json['dept'] ?? '',
      reaction: json['reaction'] ?? '',
      destruction: getDestructionFromMagnitude(magnitude),
      intensity: getIntensityFromMagnitude(magnitude),
      lat: double.tryParse(json['lat'].toString()) ?? 0.0,
      lng: double.tryParse(json['lng'].toString()) ?? 0.0,
    );
  }
}

// ✅ ฟังก์ชันคำนวณผลกระทบจาก magnitude
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
