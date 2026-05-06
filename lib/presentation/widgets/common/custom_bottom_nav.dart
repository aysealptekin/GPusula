import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;

        if (index == 0) {
          Navigator.pushReplacementNamed(context, AppRoutes.homepage);
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, AppRoutes.adventure);
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, AppRoutes.pusulaAi);
        } else if (index == 3) {
          Navigator.pushReplacementNamed(context, AppRoutes.profile);
        }
      },
      backgroundColor: const Color(0xFF0D0F14),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF7B8FF7),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: "Anasayfa",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_rounded),
          label: "Serüven",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_awesome_rounded),
          label: "Pusula AI",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: "Profil",
        ),
      ],
    );
  }
}
