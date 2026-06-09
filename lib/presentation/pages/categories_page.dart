import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/transaction/entities/transaction.dart';
import '../cubit/expense/expense_cubit.dart';
import '../cubit/expense/expense_state.dart';
import '../helpers/expense_view_helpers.dart';
import '../widgets/home/budget_category_card.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      appBar: AppBar(
        title: const Text('Kategoriler'),
        backgroundColor: AppColors.arkaplan,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = state is ExpenseLoaded
              ? state.expenses
              : <TransactionEntity>[];
          final expenses = transactions
              .where((transaction) => transaction.isExpense)
              .toList();
          final totalExpense = expenses.fold<double>(
            0,
            (total, expense) => total + expense.amount,
          );
          final categoryTotals = _categoryTotals(expenses);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: ExpenseViewHelpers.expenseCategories.map((category) {
              final amount = categoryTotals[category] ?? 0;
              final ratio = totalExpense == 0 ? 0.0 : amount / totalExpense;

              return BudgetCategoryCard(
                title: category,
                amount: '${amount.toStringAsFixed(2)} TL',
                progress: ratio.clamp(0.0, 1.0).toDouble(),
                status: amount == 0
                    ? 'YOK'
                    : '${(ratio * 100).toStringAsFixed(0)}%',
                statusColor: ExpenseViewHelpers.categoryColor(category),
                icon: ExpenseViewHelpers.categoryIcon(category),
                onTap: () => _showCategoryDetails(
                  context: context,
                  category: category,
                  transactions: transactions,
                  totalExpense: totalExpense,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Map<String, double> _categoryTotals(List<TransactionEntity> expenses) {
    final totals = <String, double>{};
    for (final expense in expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  void _showCategoryDetails({
    required BuildContext context,
    required String category,
    required List<TransactionEntity> transactions,
    required double totalExpense,
  }) {
    final categoryExpenses = transactions
        .where(
          (transaction) =>
              transaction.isExpense && transaction.category == category,
        )
        .toList();
    final amount = categoryExpenses.fold<double>(
      0,
      (total, transaction) => total + transaction.amount,
    );
    final matchAmount = categoryExpenses
        .where((transaction) => transaction.isVibeMatch)
        .fold<double>(0, (total, transaction) => total + transaction.amount);
    final missAmount = categoryExpenses
        .where((transaction) => transaction.isVibeMiss)
        .fold<double>(0, (total, transaction) => total + transaction.amount);
    final ratio = totalExpense == 0 ? 0.0 : amount / totalExpense;
    final suggestedLimit = amount == 0 ? 0.0 : amount * 0.9;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: AppColors.bgDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    ExpenseViewHelpers.categoryIcon(category),
                    color: ExpenseViewHelpers.categoryColor(category),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _CategoryDetailRow(
                label: 'Toplam harcama',
                value: '${amount.toStringAsFixed(2)} TL',
              ),
              _CategoryDetailRow(
                label: 'Toplam içindeki pay',
                value: '%${(ratio * 100).toStringAsFixed(0)}',
              ),
              _CategoryDetailRow(
                label: 'Vibe Match',
                value: '${matchAmount.toStringAsFixed(2)} TL',
              ),
              _CategoryDetailRow(
                label: 'Vibe Miss',
                value: '${missAmount.toStringAsFixed(2)} TL',
              ),
              _CategoryDetailRow(
                label: 'Önerilen limit',
                value: '${suggestedLimit.toStringAsFixed(2)} TL',
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      AppRoutes.transactions,
                      arguments: category,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primarySoft,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('İşlemleri Gör'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _CategoryDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white60)),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
