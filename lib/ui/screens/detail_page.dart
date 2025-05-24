// lib/ui/screens/detail_page.dart

import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/plants.dart';
import '../../models/disease_api.dart';
import '../../models/care_guide.dart';
import '../../services/perenual_api_service.dart';

class DetailPage extends StatefulWidget {
  final int plantId;
  const DetailPage({Key? key, required this.plantId}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Plant> _plantFuture;
  late Future<List<DiseaseApi>> _diseaseFuture;
  late Future<List<CareGuide>> _guideFuture;

  @override
  void initState() {
    super.initState();
    final svc = PerenualApiService();
    _plantFuture   = svc.fetchSpeciesDetail(widget.plantId);
    _diseaseFuture = svc.fetchDiseases(speciesId: widget.plantId);
    _guideFuture   = svc.fetchCareGuides(speciesId: widget.plantId);
  }

  /// Shows a bottom sheet listing items of type T, with a title and scroll.
  void _openModal<T>({
    required String title,
    required Future<List<T>> future,
    required Widget Function(T item) itemBuilder,
    required String emptyText,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DraggableScrollableSheet(
          expand: false,
          builder: (ctx, scroll) => Column(
            children: [
              SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 12),
              Text(title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Divider(),
              Expanded(
                child: FutureBuilder<List<T>>(
                  future: future,
                  builder: (c, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      return Center(child: Text('Error: ${snap.error}'));
                    }
                    final items = snap.data!;
                    if (items.isEmpty) return Center(child: Text(emptyText));
                    return ListView.builder(
                      controller: scroll,
                      itemCount: items.length,
                      itemBuilder: (_, i) => itemBuilder(items[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A small rectangular card showing an icon, label, and value.
  Widget _buildStatCard(IconData icon, String label, String value) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: Constants.primaryColor, size: 28),
              SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 14, color: Constants.blackColor.withOpacity(.7))),
              SizedBox(height: 4),
              Text(value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Constants.primaryColor)),
            ],
          ),
        ),
      ),
    );
  }

  /// A tappable card with a banner image, icon and title.
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required String assetPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // professional banner image
            SizedBox(
              height: 120,
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade200),
              ),
            ),
            // icon + title
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(icon, color: Constants.primaryColor),
                  SizedBox(width: 8),
                  Text(title,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Plant>(
      future: _plantFuture,
      builder: (_, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
        }
        final plant = snap.data!;
        return Scaffold(
          // favorite FAB
          floatingActionButton: FloatingActionButton(
            backgroundColor: Constants.primaryColor,
            child: Icon(
              plant.isFavorited ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () => setState(() => plant.isFavorited = !plant.isFavorited),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header image + overlay + back button + names
                Stack(
                  children: [
                    SizedBox(
                      height: 260,
                      width: double.infinity,
                      child: plant.imageUrl.isNotEmpty
                          ? Image.network(plant.imageUrl, fit: BoxFit.cover)
                          : Container(color: Colors.grey.shade200),
                    ),
                    // dark gradient
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black45, Colors.transparent],
                        ),
                      ),
                    ),
                    // common + scientific names
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plant.commonName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(plant.scientificName,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.85),
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                    // back button
                    Positioned(
                      left: 8,
                      top: MediaQuery.of(context).padding.top + 4,
                      child: BackButton(color: Colors.white),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // stats row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildStatCard(Icons.loop, 'Cycle', plant.cycle),
                      _buildStatCard(Icons.opacity, 'Watering', plant.watering),
                      _buildStatCard(
                          Icons.wb_sunny,
                          'Sunlight',
                          plant.sunlight.isNotEmpty
                              ? plant.sunlight.join(', ')
                              : 'N/A'),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // section cards
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildSectionCard(
                        title: 'Description',
                        icon: Icons.info_outline,
                        assetPath: 'assets/images/banner_description.jpg',
                        onTap: () => _openModal<String>(
                          title: 'Description',
                          future: Future.value([plant.description]),
                          emptyText: 'No description available.',
                          itemBuilder: (s) => Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              s,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: Constants.blackColor.withOpacity(.8),
                                  height: 1.5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildSectionCard(
                        title: 'Diseases',
                        icon: Icons.bug_report_outlined,
                        assetPath: 'assets/images/banner_diseases.jpg',
                        onTap: () => _openModal<DiseaseApi>(
                          title: 'Plant Diseases',
                          future: _diseaseFuture,
                          emptyText: 'No diseases found.',
                          itemBuilder: (d) => ListTile(
                            leading: d.imageUrl != null
                                ? Image.network(d.imageUrl!,
                                width: 40, height: 40, fit: BoxFit.cover)
                                : Icon(Icons.bug_report),
                            title: Text(d.commonName ?? 'Unknown'),
                            subtitle: Text(d.description ?? ''),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildSectionCard(
                        title: 'Care Guides',
                        icon: Icons.book_outlined,
                        assetPath: 'assets/images/banner_care.jpg',
                        onTap: () => _openModal<CareGuide>(
                          title: 'Care Guides',
                          future: _guideFuture,
                          emptyText: 'No care guides found.',
                          itemBuilder: (g) => ListTile(
                            leading: Icon(Icons.book_outlined,
                                color: Constants.primaryColor),
                            title: Text(g.type),
                            subtitle: Text(g.description),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
