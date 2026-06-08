import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/transaction_model.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../cubit/expense/expense_cubit.dart';
import '../cubit/expense/expense_state.dart';
import '../widgets/add_expense/add_expense_sheet.dart';
import '../widgets/common/custom_bottom_nav.dart';
import '../widgets/home/home_balance_card.dart';
import '../widgets/home/home_categories_section.dart';
import '../widgets/home/home_goals_section.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/home_transactions_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showAddExpenseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddExpenseSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    final userId = authState is Authenticated
        ? authState.user.id
        : firebaseUser?.uid;
    final userName = authState is Authenticated
        ? authState.user.name
        : firebaseUser?.displayName ?? firebaseUser?.email?.split('@').first;
    final displayName = (userName == null || userName.trim().isEmpty)
        ? 'Kullanıcı'
        : userName.trim();

    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.read<ExpenseCubit>().watchUserExpenses(userId);
        }
      });
    }

    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, expenseState) {
        final transactions = expenseState is ExpenseLoaded
            ? expenseState.expenses
            : <TransactionModel>[];
        final expenses = transactions
            .where((transaction) => transaction.isExpense)
            .toList();
        final totalExpense = expenses.fold<double>(
          0,
          (total, transaction) => total + transaction.amount,
        );
        final categoryTotals = _categoryTotals(expenses);

        return Scaffold(
          backgroundColor: AppColors.arkaplan,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(userName: displayName),
                  const SizedBox(height: 25),
                  HomeBalanceCard(totalAmount: totalExpense),
                  const SizedBox(height: 30),
                  HomeTransactionsSection(
                    expenseState: expenseState,
                    transactions: transactions,
                  ),
                  const SizedBox(height: 30),
                  HomeCategoriesSection(
                    totalExpense: totalExpense,
                    categoryTotals: categoryTotals,
                  ),
                  const SizedBox(height: 30),
                  const HomeGoalsSection(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddExpenseSheet(context),
            backgroundColor: const Color(0xFF7B8FF7),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
          bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
        );
      },
    );
  }

  Map<String, double> _categoryTotals(List<TransactionModel> expenses) {
    final totals = <String, double>{};
    for (final expense in expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }
}
