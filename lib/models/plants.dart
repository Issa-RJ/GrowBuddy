// lib/models/plants.dart

class Plant {
  final int    id;
  final String commonName;
  final String scientificName;
  final String imageUrl;
  final String description;
  final String cycle;
  final String watering;
  final List<String> sunlight;

  bool isFavorited = false;

  Plant({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.imageUrl,
    required this.description,
    required this.cycle,
    required this.watering,
    required this.sunlight,
  });

  // In-memory cache & favorites helper
  static List<Plant> _cache = [];
  static void cacheSpecies(List<Plant> list) => _cache = list;
  static List<Plant> getFavoritedPlants() =>
      _cache.where((p) => p.isFavorited).toList();

  factory Plant.fromJson(Map<String, dynamic> json) {
    // id
    final id = json['id'] as int;

    // common name
    final common = json['common_name'] as String? ?? '';

    // scientific_name might be List or String
    final sciRaw = json['scientific_name'];
    final sci = sciRaw is List
        ? sciRaw.cast<String>().join(', ')
        : (sciRaw as String? ?? '');

    // default_image.medium_url
    final img = (json['default_image'] as Map<String, dynamic>?)?['medium_url']
    as String? ?? '';

    // description: first look at top‐level, then wiki_description.value
    final descRaw = json['description'] as String?;
    final wiki =
    (json['wiki_description'] as Map<String, dynamic>?)?['value']
    as String?;
    final description = descRaw ?? wiki ?? '';

    // cycle / watering
    final cycle = json['cycle'] as String? ?? 'N/A';
    final watering = json['watering'] as String? ?? 'N/A';

    // sunlight list
    final sunRaw = json['sunlight'];
    final sunlight = sunRaw is List ? sunRaw.cast<String>() : <String>[];

    return Plant(
      id: id,
      commonName: common,
      scientificName: sci,
      imageUrl: img,
      description: description,
      cycle: cycle,
      watering: watering,
      sunlight: sunlight,
    );
  }
}
