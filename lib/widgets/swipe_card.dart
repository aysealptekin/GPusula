import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SwipeCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final String description;

  const SwipeCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20, //golgenin ne kadar bulanik olacagini ayarlar
            offset: const Offset(
              0,
              10,
            ), //golgenin x ve y eksenindeki kaymasini belirler
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ), //cerceve ekler
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 70, color: Colors.green),
          ),
          const SizedBox(height: 30),

          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$amount TL",
            style: const TextStyle(
              fontSize: 36,
              color: AppColors.arkaplan,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 30,
            ), //widgetin ic boslugunu ayarlar
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
