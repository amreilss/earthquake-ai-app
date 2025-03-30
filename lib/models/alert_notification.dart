class AlertNotification {
  final String date;
  final String area;
  final String magnitude;
  final String dept;
  final String reaction;
  final String destruction;
  final String intensity;

  AlertNotification({
    required this.date,
    required this.area,
    required this.magnitude,
    required this.dept,
    required this.reaction,
    required this.destruction,
    required this.intensity,
  });

  factory AlertNotification.fromJson(Map<String, dynamic> json) {
    return AlertNotification(
      date: json['date'] ?? '',
      area: json['area'] ?? '',
      magnitude: json['magnitude'] ?? '',
      dept: json['dept'] ?? '',
      reaction: json['reaction'] ?? '',
      destruction: json['destruction'] ?? '',
      intensity: json['intensity'] ?? '',
    );
  }
}
