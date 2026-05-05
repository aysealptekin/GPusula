import 'package:flutter/material.dart';
import 'package:roadmap/core/constants/app_colors.dart';

class RegistrationActions extends StatelessWidget
{
    final Futuree<void> Function() onRegister;
    final bool isLoading;

    const RegistrationActions
    ({
        super.key,
        required this.onRegister,
        required this.isLoading,
    })

    @override Widget build(BuildContext context)
    {
        return ElevatedButton
        (
            onPressed: isLoading ? null : onRegister,
            style: ElevatedButton.styleFrom
            (
                backgroundColor: AppColors.primarySoft,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder
                (
                    borderRadius: BorderRadius.circular(12),
                ),
            ),
            child: Text
            (
                isLoading ? "yukleniyor..." : "kayit ol",
                style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        );
    }
}