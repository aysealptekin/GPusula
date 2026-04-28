import 'package:flutter/material.dart';
import 'package:roadmap/core/constants/app_colors.dart';

class LoginHeader extends StatelessWidget
{
    const LoginHeader({super.key});

    @override Widget build(BuildContext context)
    {
        return const Column
        (
            children:
            [
                SizedBox(height: 100),
                Icon(Icons.navigation, size: 100, color: AppColors.textMain),
                SizedBox(height: 20),
                Text
                (
                    "G-PUSULA",
                    textAlign: TextAlign.center,
                    style: TextStyle
                    (
                        color: AppColors.textMain,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                    ),
                ),

                SizedBox(height: 10),

                Text(
                    "BASLA",
                    textAlign: TextAlign.center,
                    style: TextStyle
                    (
                        color: AppColors.textSecondary,
                        fontSize: 16,
                    ),
                ),
                SizedBox(height: 50),
            ],
        );
    }
}