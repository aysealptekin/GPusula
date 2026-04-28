import 'package:flutter/material.dart';
import 'package:roadmap/core/constants/app_colors.dart';

class LoginFooter extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRegister;

  const LoginFooter({
    super.key,
    required this.isLoading,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Hesabın yok mu?",
          style: TextStyle(color: AppColors.textMain),
        ),
        TextButton(
          onPressed: isLoading ? null : onRegister,
          child: const Text(
            "Kayıt Ol",
            style: TextStyle(
              color: AppColors.primarySoft,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}