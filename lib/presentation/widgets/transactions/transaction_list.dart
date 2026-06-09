import 'package:flutter/material.dart';

import '../../../domain/transaction/entities/transaction.dart';
import '../../helpers/expense_view_helpers.dart';
import '../home/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final ValueChanged<TransactionEntity> onEdit;
  final ValueChanged<TransactionEntity> onDelete;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'Bu filtrede işlem yok',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionItem(
          title: transaction.title,
          date: ExpenseViewHelpers.formatDate(transaction.createdAt),
          amount: ExpenseViewHelpers.signedAmount(transaction),
          icon: ExpenseViewHelpers.categoryIcon(transaction.category),
          color: ExpenseViewHelpers.categoryColor(transaction.category),
          statusLabel: _vibeStatusLabel(transaction),
          statusColor: _vibeStatusColor(transaction),
          onEdit: () => onEdit(transaction),
          onDelete: () => onDelete(transaction),
        );
      },
    );
  }

  String _vibeStatusLabel(TransactionEntity transaction) {
    if (transaction.isIncome) return 'Gelir';
    if (transaction.isVibeMatch) return 'Match';
    if (transaction.isVibeMiss) return 'Miss';
    return 'Pending';
  }

  Color _vibeStatusColor(TransactionEntity transaction) {
    if (transaction.isIncome) return Colors.greenAccent;
    if (transaction.isVibeMatch) return Colors.greenAccent;
    if (transaction.isVibeMiss) return Colors.orangeAccent;
    return Colors.white54;
  }
}
