import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ExpenseSaveButton extends StatelessWidget {
  final bool isSaving;
  final bool isEditing;
  final bool isIncome;
  final VoidCallback onPressed;

  const ExpenseSaveButton({
    super.key,
    required this.isSaving,
    required this.isEditing,
    required this.isIncome,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isSaving ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primarySoft,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: isSaving
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            )
          : Icon(
              isEditing
                  ? Icons.check_rounded
                  : isIncome
                  ? Icons.add_circle_outline
                  : Icons.add,
              size: 35,
              color: Colors.black,
            ),
    );
  }
}
