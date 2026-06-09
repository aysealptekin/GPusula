import 'dart:math';

import '../../transaction/entities/transaction.dart';

class SelectVibeCheckExpensesUseCase {
  const SelectVibeCheckExpensesUseCase();

  List<TransactionEntity> call(
    List<TransactionEntity> transactions, {
    DateTime? now,
  }) {
    final currentDate = now ?? DateTime.now();
    final monthlyExpenses = transactions.where((transaction) {
      return transaction.isExpense &&
          transaction.isVibePending &&
          transaction.createdAt.year == currentDate.year &&
          transaction.createdAt.month == currentDate.month;
    }).toList();

    if (monthlyExpenses.isEmpty) return const [];

    final totalExpense = monthlyExpenses.fold<double>(
      0,
      (total, transaction) => total + transaction.amount,
    );
    final threshold = max(100.0, totalExpense * 0.06);

    final importantExpenses =
        monthlyExpenses
            .where((transaction) => transaction.amount >= threshold)
            .toList()
          ..sort((first, second) => second.amount.compareTo(first.amount));

    return importantExpenses.take(8).toList();
  }

  int daysUntilMonthlyVibe({DateTime? now}) {
    final currentDate = now ?? DateTime.now();
    final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    return max(0, lastDayOfMonth.day - currentDate.day);
  }
}
