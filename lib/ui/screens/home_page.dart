// lib/ui/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../constants.dart';
import '../../models/plants.dart';
import '../../services/perenual_api_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  List<Plant> _plants = [];

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    try {
      final list = await PerenualApiService().fetchSpecies();
      Plant.cacheSpecies(list);
      setState(() => _plants = list);
    } catch (_) {
      // you could show an error UI here
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      // loading spinner only
      return const Center(child: CircularProgressIndicator());
    }

    // once loaded, show content
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) Hero carousel
          SizedBox(
            height: 260,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.8),
              itemCount: _plants.length,
              itemBuilder: (context, index) {
                final p = _plants[index];
                return _buildCarouselCard(context, p);
              },
            ),
          ),

          const SizedBox(height: 16),

          // 2) Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'All Plants',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 3) List of plants
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _plants.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final p = _plants[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: p.imageUrl.isNotEmpty
                        ? Image.network(
                      p.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                        : const SizedBox(width: 60, height: 60),
                  ),
                  title: Text(
                    p.commonName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(p.scientificName),
                  trailing: IconButton(
                    icon: Icon(
                      p.isFavorited
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Constants.primaryColor,
                    ),
                    onPressed: () {
                      setState(() => p.isFavorited = !p.isFavorited);
                    },
                  ),
                  onTap: () => Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: DetailPage(plantId: p.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselCard(BuildContext context, Plant p) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: DetailPage(plantId: p.id),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            p.imageUrl.isNotEmpty
                ? Image.network(p.imageUrl, fit: BoxFit.cover)
                : Container(color: Colors.grey.shade200),

            // Dark gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Text & favorite icon
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.commonName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.scientificName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(
                        p.isFavorited
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Constants.primaryColor,
                      ),
                      onPressed: () {
                        setState(() => p.isFavorited = !p.isFavorited);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
