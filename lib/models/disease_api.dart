// lib/models/disease_api.dart

class DiseaseApi {
  final int?      id;
  final String?   commonName;
  final String    description;   // make non-nullable, default to empty
  final String?   solution;
  final String?   imageUrl;
  final List<String>? host;

  DiseaseApi({
    this.id,
    this.commonName,
    required this.description,
    this.solution,
    this.imageUrl,
    this.host,
  });

  factory DiseaseApi.fromJson(Map<String, dynamic> json) {
    // 1) description may be a String, a List, or null
    final rawDesc = json['description'];
    final desc = rawDesc is String
        ? rawDesc
        : rawDesc is List
        ? rawDesc.join('\n')
        : (rawDesc?.toString() ?? '');

    // 2) solution may also be a String, a List, or null
    final rawSol = json['solution'];
    final sol = rawSol is String
        ? rawSol
        : rawSol is List
        ? rawSol.join('\n')
        : rawSol?.toString();

    // 3) pull out the first image’s medium_url, if any
    String? image;
    final images = json['images'];
    if (images is List && images.isNotEmpty) {
      final first = images.first;
      if (first is Map<String, dynamic>) {
        image = first['medium_url'] as String?;
      }
    }

    // 4) host can be anything, so just toString() each entry
    final rawHosts = json['host'];
    final hosts = rawHosts is List
        ? rawHosts.map((h) => h.toString()).toList()
        : null;

    return DiseaseApi(
      id:           json['id']          as int?,
      commonName:   json['common_name'] as String?,
      description:  desc,
      solution:     sol,
      imageUrl:     image,
      host:         hosts,
    );
  }
}
