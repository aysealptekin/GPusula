import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ChangePasswordHeader extends StatelessWidget {
  const ChangePasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.lock_reset, size: 55, color: AppColors.inputIcon),
        SizedBox(height: 12),
        Text(
          "Şifre Değiştir",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            color: AppColors.textMain,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Güvenliğin için yeni bir şifre belirle",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }
}
