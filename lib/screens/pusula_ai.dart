import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class PusulaAiScreen extends StatefulWidget {
  const PusulaAiScreen({super.key});

  @override
  State<PusulaAiScreen> createState() => _PusulaAiScreenState();
}

class _PusulaAiScreenState extends State<PusulaAiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      body: const Center(child: Text("ai sayfasi")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;

          if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRoutes.seruven);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, AppRoutes.profile);
          } else if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.homepage);
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
      ),
    );
  }
}
