import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/account/entities/user_profile.dart';
import '../../domain/transaction/entities/transaction.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../cubit/account/account_cubit.dart';
import '../cubit/account/account_state.dart';
import '../cubit/expense/expense_cubit.dart';
import '../cubit/expense/expense_state.dart';
import '../widgets/add_expense/add_expense_sheet.dart';
import '../widgets/common/custom_bottom_nav.dart';
import '../widgets/home/home_balance_card.dart';
import '../widgets/home/home_categories_section.dart';
import '../widgets/home/home_goals_section.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/home_transactions_section.dart';
import '../widgets/home/savings_goal_view_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFabMenuOpen = false;
  final List<SavingsGoalViewData> _goals = [];

  void _showAddExpenseSheet(BuildContext context, {required String type}) {
    setState(() => _isFabMenuOpen = false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddExpenseSheet(initialType: type),
      ),
    );
  }

  Future<void> _showAddGoalDialog() async {
    setState(() => _isFabMenuOpen = false);
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final savedController = TextEditingController();

    final added = await showDialog<SavingsGoalViewData>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1D24),
          title: const Text(
            'Hedef Ekle',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GoalDialogField(controller: titleController, hint: 'Hedef adı'),
              const SizedBox(height: 10),
              _GoalDialogField(
                controller: targetController,
                hint: 'Hedef tutar',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _GoalDialogField(
                controller: savedController,
                hint: 'Aktarılan tutar',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () {
                final target = double.tryParse(targetController.text.trim());
                final saved = double.tryParse(savedController.text.trim()) ?? 0;
                final title = titleController.text.trim();
                if (title.isEmpty || target == null || target <= 0) return;

                Navigator.pop(
                  context,
                  SavingsGoalViewData(
                    title: title,
                    targetAmount: target,
                    savedAmount: saved.clamp(0, target).toDouble(),
                    icon: Icons.flag_rounded,
                    color: AppColors.primarySoft,
                  ),
                );
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    targetController.dispose();
    savedController.dispose();

    if (added != null && mounted) {
      setState(() => _goals.add(added));
    }
  }

  Future<void> _showUpdateGoalDialog(int goalIndex) async {
    final goal = _goals[goalIndex];
    final savedController = TextEditingController(
      text: goal.savedAmount.toStringAsFixed(0),
    );

    final updatedAmount = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1D24),
          title: Text(goal.title, style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hedef: ${goal.targetAmount.toStringAsFixed(0)} TL',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              _GoalDialogField(
                controller: savedController,
                hint: 'Aktarılan tutar',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () {
                final saved = double.tryParse(savedController.text.trim());
                if (saved == null || saved < 0) return;
                Navigator.pop(
                  context,
                  saved.clamp(0, goal.targetAmount).toDouble(),
                );
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );

    savedController.dispose();

    if (updatedAmount != null && mounted) {
      setState(() {
        _goals[goalIndex] = SavingsGoalViewData(
          title: goal.title,
          targetAmount: goal.targetAmount,
          savedAmount: updatedAmount,
          icon: goal.icon,
          color: goal.color,
        );
      });
    }
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
          context.read<AccountCubit>().watchUserProfile(userId);
        }
      });
    }

    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, accountState) {
        final profile = accountState.profile;

        return BlocBuilder<ExpenseCubit, ExpenseState>(
          builder: (context, expenseState) {
            final transactions = expenseState is ExpenseLoaded
                ? expenseState.expenses
                : <TransactionEntity>[];
            final expenses = transactions
                .where((transaction) => transaction.isExpense)
                .toList();
            final totalExpense = expenses.fold<double>(
              0,
              (total, transaction) => total + transaction.amount,
            );
            final categoryTotals = _categoryTotals(expenses);
            final vibeCountdown = _vibeCountdown(profile);

            return Scaffold(
              backgroundColor: AppColors.arkaplan,
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeader(userName: displayName),
                      const SizedBox(height: 25),
                      HomeBalanceCard(
                        totalAmount: totalExpense,
                        daysUntilVibeCheck: vibeCountdown.days,
                        vibeScheduleLabel: vibeCountdown.label,
                      ),
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
                      HomeGoalsSection(
                        goals: _goals,
                        onGoalTap: _showUpdateGoalDialog,
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
              floatingActionButton: _HomeFabMenu(
                isOpen: _isFabMenuOpen,
                onToggle: () {
                  setState(() => _isFabMenuOpen = !_isFabMenuOpen);
                },
                onAddIncome: () =>
                    _showAddExpenseSheet(context, type: 'income'),
                onAddExpense: () =>
                    _showAddExpenseSheet(context, type: 'expense'),
                onAddGoal: _showAddGoalDialog,
              ),
              bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
            );
          },
        );
      },
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

  _VibeCountdown _vibeCountdown(UserProfile? profile) {
    final now = DateTime.now();
    final day = (profile?.vibeCheckDay ?? 28).clamp(1, 28).toInt();
    final frequency = profile?.vibeCheckFrequency ?? 1;
    final secondDay = (profile?.vibeCheckSecondDay ?? 15).clamp(1, 28).toInt();
    final days = frequency == 2 ? [day, secondDay] : [day];
    days.sort();
    final candidates = <DateTime>[];

    for (final targetDay in days) {
      candidates.add(DateTime(now.year, now.month, targetDay));
      candidates.add(DateTime(now.year, now.month + 1, targetDay));
    }

    candidates.sort();
    final nextDate = candidates.firstWhere(
      (date) => !date.isBefore(DateTime(now.year, now.month, now.day)),
    );
    final today = DateTime(now.year, now.month, now.day);
    final remaining = nextDate.difference(today).inDays;

    return _VibeCountdown(
      days: remaining,
      label: frequency == 2
          ? 'Ayda 2 kez: ${days.first}. gün ve ${days.last}. gün'
          : 'Her ayın $day. günü',
    );
  }
}

class _VibeCountdown {
  final int days;
  final String label;

  const _VibeCountdown({required this.days, required this.label});
}

class _HomeFabMenu extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;
  final VoidCallback onAddGoal;

  const _HomeFabMenu({
    required this.isOpen,
    required this.onToggle,
    required this.onAddIncome,
    required this.onAddExpense,
    required this.onAddGoal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: isOpen ? 210 : 64,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (isOpen) ...[
            _FabOption(
              bottom: 150,
              icon: Icons.flag_rounded,
              label: 'Hedef ekle',
              onTap: onAddGoal,
            ),
            _FabOption(
              bottom: 98,
              icon: Icons.add_circle_outline,
              label: 'Gelir ekle',
              onTap: onAddIncome,
            ),
            _FabOption(
              bottom: 46,
              icon: Icons.remove_circle_outline,
              label: 'Gider ekle',
              onTap: onAddExpense,
            ),
          ],
          FloatingActionButton(
            onPressed: onToggle,
            backgroundColor: const Color(0xFF7B8FF7),
            child: Icon(
              isOpen ? Icons.close : Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _FabOption extends StatelessWidget {
  final double bottom;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FabOption({
    required this.bottom,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: bottom,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D24),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primarySoft, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalDialogField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  const _GoalDialogField({
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
