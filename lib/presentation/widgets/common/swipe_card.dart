import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SwipeCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final String description;
  final Color? color;
  final double? progress;

  const SwipeCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.description,
    this.color,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? Colors.greenAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 70, color: accentColor),
          ),
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$amount TL",
            style: TextStyle(
              fontSize: 36,
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                minHeight: 7,
                backgroundColor: Colors.white10,
                color: accentColor,
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 30,
            ),
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
