import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant_care/constants.dart';
import 'package:plant_care/models/plants.dart';
import '../detail_page.dart';

class PlantWidget extends StatelessWidget {
  final int index;
  final List<Plant> plantList;

  PlantWidget({
    Key? key,
    required this.index,
    required this.plantList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plant = plantList[index];
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageTransition(
          child: DetailPage(plantId: plant.id),
          type: PageTransitionType.bottomToTop,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        width: size.width,
        height: 80,
        decoration: BoxDecoration(
          color: Constants.primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipOval(
              child: plant.imageUrl.isNotEmpty
                  ? Image.network(
                plant.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
                  : const SizedBox(width: 60, height: 60),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.commonName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Constants.blackColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // scientificName is a String, so just display it:
                  Text(
                    plant.scientificName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Constants.blackColor.withOpacity(.7),
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
