import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/transaction/entities/transaction.dart';
import '../cubit/expense/expense_cubit.dart';
import '../cubit/expense/expense_state.dart';
import '../helpers/expense_view_helpers.dart';
import '../widgets/common/empty_message.dart';
import '../widgets/common/swipe_card.dart';

class VibeCheckPage extends StatelessWidget {
  const VibeCheckPage({super.key});

  Future<void> _markVibe({
    required BuildContext context,
    required TransactionEntity transaction,
    required String vibeStatus,
  }) async {
    final success = await context.read<ExpenseCubit>().markVibeStatus(
          expenseId: transaction.id,
          vibeStatus: vibeStatus,
        );

    if (!context.mounted) return;

    final isMatch = vibeStatus == 'match';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? isMatch
                  ? 'Vibe Match olarak işaretlendi'
                  : 'Vibe Miss olarak işaretlendi'
              : 'Vibe değerlendirmesi kaydedilemedi',
        ),
        backgroundColor: success
            ? isMatch
                ? AppColors.success
                : Colors.orange
            : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textMain,
        title: const Text('Vibe Check'),
        centerTitle: true,
      ),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExpenseError) {
            return Center(child: EmptyMessage(message: state.message));
          }

          final transactions = state is ExpenseLoaded
              ? state.expenses
              : const <TransactionEntity>[];
          final pendingExpenses = transactions
              .where(
                (transaction) =>
                    transaction.isExpense && transaction.isVibePending,
              )
              .toList();

          if (pendingExpenses.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: EmptyMessage(
                  message:
                      'Değerlendirilecek harcama kalmadı. Yeni harcama eklediğinde Vibe Check yeniden açılır.',
                ),
              ),
            );
          }

          final transaction = pendingExpenses.first;
          final color = ExpenseViewHelpers.categoryColor(transaction.category);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                children: [
                  _VibeInstruction(
                    remainingCount: pendingExpenses.length,
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Dismissible(
                      key: ValueKey(transaction.id),
                      direction: DismissDirection.horizontal,
                      confirmDismiss: (direction) async {
                        final isMatch =
                            direction == DismissDirection.startToEnd;
                        await _markVibe(
                          context: context,
                          transaction: transaction,
                          vibeStatus: isMatch ? 'match' : 'miss',
                        );
                        return false;
                      },
                      background: const _SwipeDecisionBackground(
                        alignment: Alignment.centerLeft,
                        icon: Icons.favorite_rounded,
                        label: 'Vibe Match',
                        color: Colors.greenAccent,
                      ),
                      secondaryBackground: const _SwipeDecisionBackground(
                        alignment: Alignment.centerRight,
                        icon: Icons.replay_rounded,
                        label: 'Vibe Miss',
                        color: Colors.orangeAccent,
                      ),
                      child: SwipeCard(
                        title: transaction.title,
                        amount: transaction.amount.toStringAsFixed(2),
                        icon: ExpenseViewHelpers.categoryIcon(
                          transaction.category,
                        ),
                        color: color,
                        description:
                            '${transaction.category} harcaması. Beklentini karşıladıysa sağa, geri kazanılabilecek bir alan gibi geliyorsa sola kaydır.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _markVibe(
                            context: context,
                            transaction: transaction,
                            vibeStatus: 'miss',
                          ),
                          icon: const Icon(Icons.replay_rounded),
                          label: const Text('Vibe Miss'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orangeAccent,
                            side: const BorderSide(color: Colors.orangeAccent),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _markVibe(
                            context: context,
                            transaction: transaction,
                            vibeStatus: 'match',
                          ),
                          icon: const Icon(Icons.favorite_rounded),
                          label: const Text('Vibe Match'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primarySoft,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VibeInstruction extends StatelessWidget {
  final int remainingCount;

  const _VibeInstruction({required this.remainingCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.swipe_rounded, color: AppColors.primarySoft),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$remainingCount harcama değerlendirme bekliyor. Sağa değer yaratan, sola beklentiyi karşılamayan harcama.',
              style: const TextStyle(color: Colors.white70, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeDecisionBackground extends StatelessWidget {
  final Alignment alignment;
  final IconData icon;
  final String label;
  final Color color;

  const _SwipeDecisionBackground({
    required this.alignment,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
