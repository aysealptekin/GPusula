import 'package:flutter/material.dart';

import '../../data/models/transaction_model.dart';

class ExpenseViewHelpers {
  static const expenseCategories = [
    'Yemek',
    'Market',
    'Ulaşım',
    'Eğlence',
    'Diğer',
  ];

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday =
        now.year == date.year && now.month == date.month && now.day == date.day;

    if (isToday) {
      return 'Bugün, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  static String signedAmount(TransactionModel transaction) {
    final prefix = transaction.isIncome ? '+' : '-';
    return '$prefix${transaction.amount.toStringAsFixed(2)} TL';
  }

  static IconData categoryIcon(String category) {
    switch (category) {
      case 'Gelir':
        return Icons.payments_rounded;
      case 'Yemek':
        return Icons.restaurant;
      case 'Market':
        return Icons.shopping_cart;
      case 'Ulaşım':
        return Icons.directions_bus;
      case 'Eğlence':
        return Icons.confirmation_number;
      default:
        return Icons.more_horiz;
    }
  }

  static Color categoryColor(String category) {
    switch (category) {
      case 'Gelir':
        return Colors.greenAccent;
      case 'Yemek':
        return Colors.orangeAccent;
      case 'Market':
        return Colors.lightGreenAccent;
      case 'Ulaşım':
        return Colors.lightBlueAccent;
      case 'Eğlence':
        return Colors.pinkAccent;
      default:
        return Colors.purpleAccent;
    }
  }
}
