import '../../../core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ChangePasswordActions extends StatelessWidget {
  final VoidCallback onExecute;

  const ChangePasswordActions({super.key, required this.onExecute});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onExecute,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primarySoft,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        "ŞİFREYİ DEĞİŞTİR",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
