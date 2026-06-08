import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../domain/transaction/entities/transaction.dart';
import '../../cubit/expense/expense_state.dart';
import '../../helpers/expense_view_helpers.dart';
import '../common/empty_message.dart';
import 'home_section_header.dart';
import 'transaction_item.dart';

class HomeTransactionsSection extends StatelessWidget {
  final ExpenseState expenseState;
  final List<TransactionEntity> transactions;

  const HomeTransactionsSection({
    super.key,
    required this.expenseState,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeSectionHeader(
          title: 'Son İşlemler',
          onSeeAll: () => Navigator.pushNamed(context, AppRoutes.transactions),
        ),
        const SizedBox(height: 15),
        if (expenseState is ExpenseLoading)
          const Center(child: CircularProgressIndicator())
        else if (transactions.isEmpty)
          const EmptyMessage(message: 'Henüz işlem eklenmedi')
        else
          ...transactions
              .take(5)
              .map(
                (transaction) => TransactionItem(
                  title: transaction.title,
                  date: ExpenseViewHelpers.formatDate(transaction.createdAt),
                  amount: ExpenseViewHelpers.signedAmount(transaction),
                  icon: ExpenseViewHelpers.categoryIcon(transaction.category),
                  color: ExpenseViewHelpers.categoryColor(transaction.category),
                ),
              ),
      ],
    );
  }
}
