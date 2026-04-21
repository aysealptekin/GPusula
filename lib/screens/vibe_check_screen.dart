import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/swipe_card.dart';

class VibeCheckScreen extends StatelessWidget {
  const VibeCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Time to Vibe Check",
          style: TextStyle(color: AppColors.textMain),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SwipeCard(
                  title: "yemek",
                  amount: "30",
                  icon: Icons.food_bank,
                  description: "bu ay yemege 30tl kadar harcadin",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
