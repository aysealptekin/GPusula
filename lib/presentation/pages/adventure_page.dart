import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/transaction/entities/transaction.dart';
import '../../domain/vibe/usecases/build_vibe_report_usecase.dart';
import '../cubit/expense/expense_cubit.dart';
import '../cubit/expense/expense_state.dart';
import '../helpers/expense_view_helpers.dart';
import '../widgets/common/custom_bottom_nav.dart';
import '../widgets/common/empty_message.dart';

class AdventurePage extends StatelessWidget {
  const AdventurePage({super.key});

  static const _buildVibeReportUseCase = BuildVibeReportUseCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      appBar: AppBar(
        title: const Text('Serüven'),
        backgroundColor: AppColors.arkaplan,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = state is ExpenseLoaded
              ? state.expenses
              : const <TransactionEntity>[];
          final expenses = transactions
              .where((transaction) => transaction.isExpense)
              .toList();
          final pendingCount = expenses
              .where((transaction) => transaction.isVibePending)
              .length;

          if (expenses.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: EmptyMessage(
                  message: 'Serüvenini başlatmak için birkaç harcama ekle',
                ),
              ),
            );
          }

          final report = _buildVibeReportUseCase(transactions);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _VibeCheckCallout(
                pendingCount: pendingCount,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.vibeCheck,
                ),
              ),
              const SizedBox(height: 18),
              _PersonaCard(
                persona: report.persona,
                matchedAmount: report.matchedAmount,
                missedAmount: report.missedAmount,
              ),
              const SizedBox(height: 18),
              _RoadmapCard(roadmap: report.roadmap),
              const SizedBox(height: 22),
              const Text(
                'Vibe Match Kategorileri',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              if (report.matches.isEmpty)
                const EmptyMessage(
                  message:
                      'Henüz Vibe Match yok. Değer yaratan harcamalarını sağa kaydırarak hikayeni oluştur.',
                )
              else
                ...report.matches.map(
                  (match) => _VibeMatchTile(
                    category: match.category,
                    title: match.title,
                    amount: match.amount,
                    ratio: match.ratio,
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}

class _VibeCheckCallout extends StatelessWidget {
  final int pendingCount;
  final VoidCallback onTap;

  const _VibeCheckCallout({
    required this.pendingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D24),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.primarySoft.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.swipe_rounded,
                color: AppColors.primarySoft,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vibe Check',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pendingCount == 0
                        ? 'Tüm harcamalar değerlendirildi'
                        : '$pendingCount harcama karar bekliyor',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class _PersonaCard extends StatelessWidget {
  final String persona;
  final double matchedAmount;
  final double missedAmount;

  const _PersonaCard({
    required this.persona,
    required this.matchedAmount,
    required this.missedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ay sonu hikayen',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            persona,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _AmountPill(
                  label: 'Vibe Match',
                  amount: matchedAmount,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AmountPill(
                  label: 'Vibe Miss',
                  amount: missedAmount,
                  color: Colors.orangeAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountPill extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _AmountPill({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            '${amount.toStringAsFixed(2)} TL',
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

class _RoadmapCard extends StatelessWidget {
  final String roadmap;

  const _RoadmapCard({required this.roadmap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.route_rounded, color: AppColors.primarySoft),
          const SizedBox(width: 12),
          Expanded(
            child: _RoadmapText(roadmap: roadmap),
          ),
        ],
      ),
    );
  }
}

class _RoadmapText extends StatelessWidget {
  final String roadmap;

  const _RoadmapText({required this.roadmap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Potansiyel Enerji',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          roadmap,
          style: const TextStyle(color: Colors.white70, height: 1.35),
        ),
      ],
    );
  }
}

class _VibeMatchTile extends StatelessWidget {
  final String category;
  final String title;
  final double amount;
  final double ratio;

  const _VibeMatchTile({
    required this.category,
    required this.title,
    required this.amount,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    final color = ExpenseViewHelpers.categoryColor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(ExpenseViewHelpers.categoryIcon(category), color: color),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${amount.toStringAsFixed(2)} TL',
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
          Text(
            '%${(ratio * 100).round()}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
