import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/expense/entities/expense.dart';
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
              : <Expense>[];
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
                status: amount == 0 ? 'YOK' : '${(ratio * 100).toStringAsFixed(0)}%',
                statusColor: ExpenseViewHelpers.categoryColor(category),
                icon: ExpenseViewHelpers.categoryIcon(category),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.transactions,
                  arguments: category,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Map<String, double> _categoryTotals(List<Expense> expenses) {
    final totals = <String, double>{};
    for (final expense in expenses) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }
}
