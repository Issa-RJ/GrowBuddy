// lib/ui/screens/root_page.dart

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plant_care/constants.dart';
import 'package:plant_care/models/plants.dart';
import 'package:plant_care/ui/scan_page.dart';
import 'package:plant_care/ui/screens/favorite_page.dart';
import 'package:plant_care/ui/screens/advice_page.dart';
import 'package:plant_care/ui/screens/profile_page.dart';
import 'package:plant_care/ui/screens/home_page.dart';
import 'package:plant_care/ui/screens/community/feed_page.dart';
import 'package:page_transition/page_transition.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  List<Plant> favorites = Plant.getFavoritedPlants();
  int _bottomNavIndex = 0;

  // 4 bottom‐nav icons: Home, Favorites, Advice, Profile
  final List<IconData> _iconList = [
    Icons.home,
    Icons.favorite,
    Icons.book,      // Advice
    Icons.person,    // Profile
  ];

  // Corresponding titles
  final List<String> _titleList = [
    'Home',
    'Favorites',
    'Advice',
    'Profile',
  ];

  // The four main pages
  List<Widget> get _pages => [
    const HomePage(),
    FavoritePage(favoritedPlants: favorites),
    const AdvicePage(),
    const ProfilePage(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _bottomNavIndex = index;
      favorites = Plant.getFavoritedPlants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ─── Single AppBar with Community action ───────────────────
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.plantWilt,
                color: Constants.primaryColor, size: 24),
            const SizedBox(width: 8),
            Text(
              _titleList[_bottomNavIndex],
              style: TextStyle(
                color: Constants.blackColor,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.forum, color: Constants.primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: const FeedPage(),
                ),
              );
            },
          ),
        ],
      ),

      // ─── Body is one of the four pages ────────────────────────
      body: IndexedStack(
        index: _bottomNavIndex,
        children: _pages,
      ),

      // ─── Central FAB for Scan ─────────────────────────────────
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.primaryColor,
        onPressed: () => Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const ScanPage(),
          ),
        ),
        child: Image.asset(
          'assets/images/code-scan-two.png',
          height: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ─── 4-icon bottom nav, even count so center notch works ──
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _iconList,
        activeIndex: _bottomNavIndex,
        activeColor: Constants.primaryColor,
        inactiveColor: Colors.black.withOpacity(.5),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        splashColor: Constants.primaryColor,
        onTap: _onNavTap,
      ),
    );
  }
}
