import 'package:flutter/material.dart';
import 'package:roadmap/core/constants/app_colors.dart';

class LoginActions extends StatelessWidget 
{
  final bool isLoading;
  final VoidCallback onForgotPassword;
  final VoidCallback onLogin;
  final VoidCallback onGoogleSignIn;

  const LoginActions
  (
    {
    super.key,
    required this.isLoading,
    required this.onForgotPassword,
    required this.onLogin,
    required this.onGoogleSignIn,
    }
 );

  @override
  Widget build(BuildContext context) 
  {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: isLoading ? null : onForgotPassword,
            child: const Text(
              "Şifremi Unuttum",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : onLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primarySoft,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            isLoading ? "Yükleniyor..." : "GİRİŞ YAP",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon
        (
          onPressed: isLoading ? null : onGoogleSignIn,
          icon: const Icon(Icons.g_mobiledata, size: 30),
          label: Text
          (
            isLoading ? "Yükleniyor..." : "Google ile Devam Et",
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textMain,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}