import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/transaction/entities/transaction.dart';
import '../cubit/expense/expense_cubit.dart';
import '../cubit/expense/expense_state.dart';
import '../helpers/expense_view_helpers.dart';
import '../widgets/common/custom_bottom_nav.dart';
import '../widgets/common/empty_message.dart';

class PusulaAiPage extends StatelessWidget {
  const PusulaAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      appBar: AppBar(
        title: const Text('Pusula AI'),
        backgroundColor: AppColors.arkaplan,
        foregroundColor: Colors.white,
        elevation: 0,
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

          if (transactions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: EmptyMessage(
                  message: 'Öneri üretmek için önce gelir veya gider ekle',
                ),
              ),
            );
          }

          final summary = _InsightSummary.fromTransactions(transactions);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _AiHeaderCard(summary: summary),
              const SizedBox(height: 18),
              _InsightCard(
                icon: Icons.account_balance_wallet_rounded,
                title: 'Net durum',
                description: summary.netBalance >= 0
                    ? 'Gelirlerin giderlerinden önde. Bu tempoyu korursan birikim hedeflerine alan açılır.'
                    : 'Giderlerin gelirlerini geçmiş. Bu ay küçük bir kategori limiti belirlemek iyi olur.',
                color: summary.netBalance >= 0
                    ? Colors.greenAccent
                    : Colors.redAccent,
              ),
              _InsightCard(
                icon: ExpenseViewHelpers.categoryIcon(summary.topCategory),
                title: 'Dikkat çeken kategori',
                description:
                    '${summary.topCategory} tarafında ${summary.topCategoryAmount.toStringAsFixed(2)} TL harcama var. Bu alan ayın en güçlü sinyali.',
                color: ExpenseViewHelpers.categoryColor(summary.topCategory),
              ),
              _InsightCard(
                icon: Icons.flag_rounded,
                title: 'Mini görev',
                description:
                    'Sonraki harcamanda ${summary.topCategory} için kendine küçük bir üst sınır koy ve Serüven ekranından etkisini takip et.',
                color: AppColors.primarySoft,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }
}

class _InsightSummary {
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final String topCategory;
  final double topCategoryAmount;

  const _InsightSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.topCategory,
    required this.topCategoryAmount,
  });

  factory _InsightSummary.fromTransactions(
    List<TransactionEntity> transactions,
  ) {
    var totalIncome = 0.0;
    var totalExpense = 0.0;
    final categoryTotals = <String, double>{};

    for (final transaction in transactions) {
      if (transaction.isIncome) {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
        categoryTotals[transaction.category] =
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      }
    }

    var topCategory = 'Diğer';
    var topCategoryAmount = 0.0;
    for (final entry in categoryTotals.entries) {
      if (entry.value > topCategoryAmount) {
        topCategory = entry.key;
        topCategoryAmount = entry.value;
      }
    }

    return _InsightSummary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netBalance: totalIncome - totalExpense,
      topCategory: topCategory,
      topCategoryAmount: topCategoryAmount,
    );
  }
}

class _AiHeaderCard extends StatelessWidget {
  final _InsightSummary summary;

  const _AiHeaderCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primarySoft.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: AppColors.primarySoft),
              SizedBox(width: 10),
              Text(
                'Finans pusulan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MetricText(
                  label: 'Gelir',
                  value: '${summary.totalIncome.toStringAsFixed(2)} TL',
                  color: Colors.greenAccent,
                ),
              ),
              Expanded(
                child: _MetricText(
                  label: 'Gider',
                  value: '${summary.totalExpense.toStringAsFixed(2)} TL',
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _MetricText(
            label: 'Net',
            value: '${summary.netBalance.toStringAsFixed(2)} TL',
            color: summary.netBalance >= 0
                ? Colors.greenAccent
                : Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

class _MetricText extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricText({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _InsightCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
