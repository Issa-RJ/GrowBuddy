// lib/ui/screens/favorite_page.dart

import 'package:flutter/material.dart';
import 'package:plant_care/constants.dart';
import 'package:plant_care/models/plants.dart';
import 'package:page_transition/page_transition.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  final List<Plant> favoritedPlants;
  const FavoritePage({Key? key, required this.favoritedPlants})
      : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favs = widget.favoritedPlants;

    if (favs.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 120,
                child: Image.asset('assets/images/favorited.png'),
              ),
              const SizedBox(height: 16),
              Text(
                'لا توجد نباتات مفضلة',
                style: TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: favs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, index) {
          final plant = favs[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: DetailPage(plantId: plant.id),
                    type: PageTransitionType.bottomToTop,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Large circular image
                    ClipOval(
                      child: plant.imageUrl.isNotEmpty
                          ? Image.network(
                        plant.imageUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey.shade200,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Name and scientific name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.commonName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Constants.blackColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plant.scientificName,
                            style: TextStyle(
                              fontSize: 14,
                              color: Constants.blackColor.withOpacity(.6),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Favorite toggle
                    IconButton(
                      icon: Icon(
                        plant.isFavorited
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Constants.primaryColor,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          plant.isFavorited = !plant.isFavorited;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
