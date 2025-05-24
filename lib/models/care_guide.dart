// lib/models/care_guide.dart

class CareGuide {
  final String type;
  final String description;

  CareGuide({required this.type, required this.description});

  factory CareGuide.fromJson(Map<String, dynamic> json) {
    // Each guide has a "type" and "description"
    final type = json['type'] as String? ?? '';
    final desc = json['description'] as String? ?? '';
    return CareGuide(type: type, description: desc);
  }
}
