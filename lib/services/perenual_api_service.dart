// lib/services/perenual_api_service.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/plants.dart';
import '../models/disease_api.dart';
import '../models/care_guide.dart';

/// Model for Plant.id identification results, including care details.
class PlantIdentification {
  final String name;
  final double probability;
  final Map<String, dynamic>? details;

  PlantIdentification({
    required this.name,
    required this.probability,
    this.details,
  });
}

class PerenualApiService {
  // ─── Perenual API keys & endpoints ─────────────────────────────────────────
  final String _key    = dotenv.env['PERENUAL_API_KEY']!;
  final String _v2Base = 'https://perenual.com/api/v2';
  final String _base   = 'https://perenual.com/api';

  // ─── species (v2) ──────────────────────────────────────────────────────────
  Future<List<Plant>> fetchSpecies({int page = 1, String? q}) async {
    final uri = Uri.parse('$_v2Base/species-list').replace(
      queryParameters: {
        'key' : _key,
        'page': '$page',
        if (q != null) 'q': q,
      },
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('species-list ${res.statusCode}');
    }
    final raw  = jsonDecode(res.body) as Map<String, dynamic>;
    final data = raw['data'] as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(Plant.fromJson).toList();
  }

  Future<Plant> fetchSpeciesDetail(int id) async {
    final uri = Uri.parse('$_v2Base/species/details/$id?key=$_key');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('species-details ${res.statusCode}');
    }
    final body    = jsonDecode(res.body) as Map<String, dynamic>;
    final payload = (body['data'] is Map<String, dynamic>)
        ? body['data'] as Map<String, dynamic>
        : body;
    return Plant.fromJson(payload);
  }

  // ─── pest/disease (v1) ─────────────────────────────────────────────────────
  Future<List<DiseaseApi>> fetchDiseases({
    int page = 1,
    String? q,
    int? speciesId,
  }) async {
    final uri = Uri.parse('$_base/pest-disease-list').replace(
      queryParameters: {
        'key' : _key,
        'page': '$page',
        if (q != null)         'q' : q,
        if (speciesId != null) 'id': '$speciesId',
      },
    );
    final res = await http.get(uri);
    final ct  = res.headers['content-type'] ?? '';
    if (!ct.contains('application/json')) return <DiseaseApi>[];
    final raw  = jsonDecode(res.body) as Map<String, dynamic>;
    final list = raw['data'] as List<dynamic>;
    return list.cast<Map<String, dynamic>>().map(DiseaseApi.fromJson).toList();
  }

  // ─── care-guide (v1) ─────────────────────────────────────────────────────────
  Future<List<CareGuide>> fetchCareGuides({
    int page = 1,
    int? speciesId,
    String? type,
  }) async {
    final uri = Uri.parse('$_base/species-care-guide-list').replace(
      queryParameters: {
        'key'         : _key,
        'page'        : '$page',
        if (speciesId != null) 'species_id': '$speciesId',
        if (type      != null) 'type'      : type,
      },
    );
    final res = await http.get(uri);
    final ct  = res.headers['content-type'] ?? '';
    if (!ct.contains('application/json')) return <CareGuide>[];

    final raw     = jsonDecode(res.body) as Map<String, dynamic>;
    final species = raw['data'] as List<dynamic>;
    final sections = species.cast<Map<String, dynamic>>()
        .expand((spec) => (spec['section'] as List<dynamic>).cast<Map<String, dynamic>>())
        .toList();
    return sections.map(CareGuide.fromJson).toList();
  }

  // ─── Plant.id v3 integration ─────────────────────────────────────────────────

  /// Sends [imageFile] to Plant.id and returns a rich result including care details.
  Future<PlantIdentification> identifyPlant(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final b64   = base64Encode(bytes);
    final apiKey = dotenv.env['PLANT_ID_API_KEY']!;

    // Accept 200 or 201 (job created)
    final uri = Uri.parse(
      'https://plant.id/api/v3/identification'
          '?details=common_names,probability,description,best_watering,best_light_condition,best_soil_type,propagation_methods,edible_parts,toxicity'
          '&language=en',
    );

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Api-Key'     : apiKey,
      },
      body: jsonEncode({
        'images'              : [b64],
        'similar_images'      : true,
        'classification_level': 'species',
        'classification_raw'  : true,
        'health'              : 'all',
      }),
    );

    if (!(res.statusCode == 200 || res.statusCode == 201)) {
      throw Exception('Plant.id HTTP ${res.statusCode}: ${res.body}');
    }

    final raw = jsonDecode(res.body) as Map<String, dynamic>;
    final result = raw['result'] as Map<String, dynamic>;
    final classification = result['classification'] as Map<String, dynamic>;
    final suggestions = classification['suggestions'] as Map<String, dynamic>;

    List<dynamic>? speciesList = suggestions['species'] as List<dynamic>?;
    if (speciesList == null || speciesList.isEmpty) {
      // fallback to genus if no species
      speciesList = suggestions['genus'] as List<dynamic>?;
    }
    final top = (speciesList != null && speciesList.isNotEmpty)
        ? speciesList.first as Map<String, dynamic>
        : <String, dynamic>{'name':'Unknown','probability':0.0};

    final details = raw['details'] as Map<String, dynamic>?;

    return PlantIdentification(
      name: top['name'] as String,
      probability: (top['probability'] as num).toDouble(),
      details: details,
    );
  }
}
