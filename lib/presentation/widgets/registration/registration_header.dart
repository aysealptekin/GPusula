import 'package:flutter/material.dart';
import 'package:roadmap/core/constants/app_colors.dart';
class RegistrationHeader extends StatelessWidget {
    const RegistrationHeader({super.key});

    @override
    Widget build(BuildContext context)
    {
        return const Column(
            children: [
                Icon(
                  Icons.person_add,
                  size: 50,
                  color: AppColors.inputIcon,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Yeni Hesap Oluştur',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: AppColors.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

            ]

        );
    }

}