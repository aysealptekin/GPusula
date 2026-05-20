import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/expense/entities/expense.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../cubit/expense/expense_cubit.dart';
import '../cubit/expense/expense_state.dart';
import '../helpers/expense_view_helpers.dart';
import '../widgets/add_expense/add_expense_sheet.dart';
import '../widgets/common/custom_bottom_nav.dart';
import '../widgets/home/budget_category_card.dart';
import '../widgets/home/goal_card.dart';
import '../widgets/home/home_balance_card.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/transaction_item.dart';

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
            : <Expense>[];
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
                  _SectionHeader(
                    title: 'Son İşlemler',
                    onSeeAll: () =>
                        Navigator.pushNamed(context, AppRoutes.transactions),
                  ),
                  const SizedBox(height: 15),
                  if (expenseState is ExpenseLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (transactions.isEmpty)
                    const _EmptyState(message: 'Henüz işlem eklenmedi')
                  else
                    ...transactions.take(5).map(
                      (transaction) => TransactionItem(
                        title: transaction.title,
                        date: ExpenseViewHelpers.formatDate(
                          transaction.createdAt,
                        ),
                        amount: ExpenseViewHelpers.signedAmount(transaction),
                        icon: ExpenseViewHelpers.categoryIcon(
                          transaction.category,
                        ),
                        color: ExpenseViewHelpers.categoryColor(
                          transaction.category,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  _SectionHeader(
                    title: 'Kategoriler',
                    onSeeAll: () =>
                        Navigator.pushNamed(context, AppRoutes.categories),
                  ),
                  const SizedBox(height: 15),
                  if (categoryTotals.isEmpty)
                    const _EmptyState(message: 'Kategori özeti için harcama ekle')
                  else
                    ...categoryTotals.entries.map(
                      (entry) => BudgetCategoryCard(
                        title: entry.key,
                        amount: '${entry.value.toStringAsFixed(2)} TL',
                        progress: totalExpense == 0
                            ? 0
                            : (entry.value / totalExpense)
                                  .clamp(0.0, 1.0)
                                  .toDouble(),
                        status: 'GİDER',
                        statusColor: ExpenseViewHelpers.categoryColor(
                          entry.key,
                        ),
                        icon: ExpenseViewHelpers.categoryIcon(entry.key),
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.transactions,
                          arguments: entry.key,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  const Text(
                    'Birikim Hedefleri',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Expanded(
                        child: GoalCard(
                          title: 'Tasarruf',
                          amount: '12,500 TL',
                          progress: 0.72,
                          icon: Icons.wallet,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: GoalCard(
                          title: 'Tatil',
                          amount: '8,200 TL',
                          progress: 0.45,
                          icon: Icons.flight,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
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

  Map<String, double> _categoryTotals(List<Expense> expenses) {
    final totals = <String, double>{};
    for (final expense in expenses) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          onTap: onSeeAll,
          child: const Text(
            'Tümünü Gör',
            style: TextStyle(color: Color(0xFF7B8FF7)),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
