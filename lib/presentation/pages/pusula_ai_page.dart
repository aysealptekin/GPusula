import 'package:flutter/material.dart';
import 'package:roadmap/presentation/widgets/common/custom_bottom_nav.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class PusulaAiPage extends StatefulWidget {
  const PusulaAiPage({super.key});

  @override
  State<PusulaAiPage> createState() => _PusulaAiPageState();
}

class _PusulaAiPageState extends State<PusulaAiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      body: const Center(child: Text("ai sayfasi")),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }
}
