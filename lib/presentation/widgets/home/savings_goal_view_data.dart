import 'package:flutter/material.dart';

class SavingsGoalViewData {
  final String title;
  final double targetAmount;
  final double savedAmount;
  final IconData icon;
  final Color color;

  const SavingsGoalViewData({
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.icon,
    required this.color,
  });

  double get remainingAmount =>
      (targetAmount - savedAmount).clamp(0, targetAmount).toDouble();

  double get progress => targetAmount == 0 ? 0 : savedAmount / targetAmount;
}
