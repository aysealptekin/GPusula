import 'package:flutter/material.dart';
import 'package:roadmap/presentation/widgets/common/custom_bottom_nav.dart';
import '../../core/constants/app_colors.dart';

class AdventurePage extends StatefulWidget {
  const AdventurePage({super.key});

  @override
  State<AdventurePage> createState() => _AdventurePageState();
}

class _AdventurePageState extends State<AdventurePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      body: const Center(
        child: Text("seruven vibe check vibe match aylik ozet"),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}
