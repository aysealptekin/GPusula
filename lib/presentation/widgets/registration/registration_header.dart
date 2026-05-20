import 'package:flutter/material.dart';
import 'package:roadmap/core/constants/app_colors.dart';

class RegistrationHeader extends StatelessWidget {
  const RegistrationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.person_add, size: 50, color: AppColors.inputIcon),
        SizedBox(height: 10),
        Text(
          'Yeni Hesap OluÅŸtur',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: AppColors.textMain,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
