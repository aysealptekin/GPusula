import 'package:flutter/material.dart';

import '../../../data/models/transaction_model.dart';
import '../../helpers/expense_view_helpers.dart';
import '../home/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final ValueChanged<TransactionModel> onEdit;
  final ValueChanged<TransactionModel> onDelete;

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
          onEdit: () => onEdit(transaction),
          onDelete: () => onDelete(transaction),
        );
      },
    );
  }
}
