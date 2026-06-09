import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/account/entities/user_profile.dart';
import '../../domain/transaction/entities/transaction.dart';
import '../../domain/vibe/usecases/build_vibe_report_usecase.dart';
import '../../domain/vibe/usecases/select_vibe_check_expenses_usecase.dart';
import '../cubit/account/account_cubit.dart';
import '../cubit/expense/expense_cubit.dart';
import '../cubit/expense/expense_state.dart';
import '../helpers/expense_view_helpers.dart';
import '../widgets/common/custom_bottom_nav.dart';
import '../widgets/common/empty_message.dart';
import '../widgets/common/swipe_card.dart';

enum _VibeCheckStep { welcome, swiping, analyzing, story }

class VibeCheckPage extends StatefulWidget {
  const VibeCheckPage({super.key});

  @override
  State<VibeCheckPage> createState() => _VibeCheckPageState();
}

class _VibeCheckPageState extends State<VibeCheckPage> {
  static const _selectVibeCheckExpensesUseCase =
      SelectVibeCheckExpensesUseCase();
  static const _buildVibeReportUseCase = BuildVibeReportUseCase();

  _VibeCheckStep _step = _VibeCheckStep.welcome;
  List<TransactionEntity> _sessionExpenses = [];
  int _currentIndex = 0;
  Timer? _analysisTimer;

  @override
  void dispose() {
    _analysisTimer?.cancel();
    super.dispose();
  }

  void _startAdventure(List<TransactionEntity> transactions) {
    final selectedExpenses = _selectVibeCheckExpensesUseCase(transactions);
    setState(() {
      _sessionExpenses = selectedExpenses;
      _currentIndex = 0;
      _step = selectedExpenses.isEmpty
          ? _VibeCheckStep.story
          : _VibeCheckStep.swiping;
    });
  }

  Future<void> _markVibe({
    required TransactionEntity transaction,
    required String vibeStatus,
  }) async {
    await context.read<ExpenseCubit>().markVibeStatus(
      expenseId: transaction.id,
      vibeStatus: vibeStatus,
    );

    if (!mounted) return;

    if (_currentIndex + 1 >= _sessionExpenses.length) {
      _showAnalysis();
      return;
    }

    setState(() => _currentIndex++);
  }

  void _showAnalysis() {
    setState(() => _step = _VibeCheckStep.analyzing);
    _analysisTimer?.cancel();
    _analysisTimer = Timer(const Duration(milliseconds: 3400), () {
      if (!mounted) return;
      setState(() => _step = _VibeCheckStep.story);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AccountCubit>().state.profile;
    final daysUntilVibeCheck = _daysUntilNextVibeCheck(profile);

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

          return SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: switch (_step) {
                _VibeCheckStep.welcome => _WelcomeView(
                  key: const ValueKey('welcome'),
                  transactions: transactions,
                  daysUntilVibeCheck: daysUntilVibeCheck,
                  selectedCount: _selectVibeCheckExpensesUseCase(
                    transactions,
                  ).length,
                  onStart: () => _startAdventure(transactions),
                ),
                _VibeCheckStep.swiping => _SwipingView(
                  key: const ValueKey('swiping'),
                  expenses: _sessionExpenses,
                  currentIndex: _currentIndex,
                  onMatch: (transaction) =>
                      _markVibe(transaction: transaction, vibeStatus: 'match'),
                  onMiss: (transaction) =>
                      _markVibe(transaction: transaction, vibeStatus: 'miss'),
                ),
                _VibeCheckStep.analyzing => const _AnalyzingView(
                  key: ValueKey('analyzing'),
                ),
                _VibeCheckStep.story => _StoryView(
                  key: const ValueKey('story'),
                  transactions: transactions,
                  onRestart: () {
                    setState(() => _step = _VibeCheckStep.welcome);
                  },
                ),
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  int _daysUntilNextVibeCheck(UserProfile? profile) {
    final now = DateTime.now();
    final firstDay = (profile?.vibeCheckDay ?? 28).clamp(1, 28).toInt();
    final secondDay = (profile?.vibeCheckSecondDay ?? 15).clamp(1, 28).toInt();
    final frequency = profile?.vibeCheckFrequency ?? 1;
    final targetDays = frequency == 2 ? [firstDay, secondDay] : [firstDay];
    final today = DateTime(now.year, now.month, now.day);
    final candidates = <DateTime>[];

    for (final targetDay in targetDays) {
      candidates.add(DateTime(now.year, now.month, targetDay));
      candidates.add(DateTime(now.year, now.month + 1, targetDay));
    }

    candidates.sort();
    final nextDate = candidates.firstWhere((date) => !date.isBefore(today));

    return nextDate.difference(today).inDays;
  }
}

class _WelcomeView extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final int daysUntilVibeCheck;
  final int selectedCount;
  final VoidCallback onStart;

  const _WelcomeView({
    super.key,
    required this.transactions,
    required this.daysUntilVibeCheck,
    required this.selectedCount,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final expenseCount = transactions
        .where(
          (transaction) => transaction.isExpense && transaction.isVibePending,
        )
        .length;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
            children: [
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D24),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: AppColors.primarySoft.withValues(alpha: 0.22),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.primarySoft,
                      size: 40,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Aylık Vibe Check’e hoş geldin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      daysUntilVibeCheck == 0
                          ? 'Bu ayın finans hikayesi hazır.'
                          : 'Planladığın Vibe Check gününe $daysUntilVibeCheck gün var; test için şimdi başlatabilirsin.',
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _WelcomeMetricRow(
                      pendingCount: expenseCount,
                      selectedCount: selectedCount,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const _RuleTile(
                icon: Icons.trending_up_rounded,
                title: 'Sadece önemli harcamalar',
                description:
                    'Küçük akbil veya ufak market fişleri yerine ayını etkileyen harcamalar sorulur.',
              ),
              const _RuleTile(
                icon: Icons.swipe_rounded,
                title: 'Sağa Match, sola Miss',
                description:
                    'Değer yaratan harcamaları sağa; beklentiyi karşılamayanları sola kaydır.',
              ),
              const _RuleTile(
                icon: Icons.auto_stories_rounded,
                title: 'Sonunda hikaye',
                description:
                    'Kararların bittikten sonra ay sonu hikayen Spotify Wrapped gibi açılır.',
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: selectedCount == 0 ? null : onStart,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                selectedCount == 0 ? 'Önemli harcama yok' : 'Serüveni Başlat',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primarySoft,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WelcomeMetricRow extends StatelessWidget {
  final int pendingCount;
  final int selectedCount;

  const _WelcomeMetricRow({
    required this.pendingCount,
    required this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricBox(label: 'Bekleyen', value: '$pendingCount'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricBox(label: 'Seçilen', value: '$selectedCount'),
        ),
      ],
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;

  const _MetricBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _RuleTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primarySoft),
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white60, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipingView extends StatelessWidget {
  final List<TransactionEntity> expenses;
  final int currentIndex;
  final ValueChanged<TransactionEntity> onMatch;
  final ValueChanged<TransactionEntity> onMiss;

  const _SwipingView({
    super.key,
    required this.expenses,
    required this.currentIndex,
    required this.onMatch,
    required this.onMiss,
  });

  @override
  Widget build(BuildContext context) {
    final transaction = expenses[currentIndex];
    final color = ExpenseViewHelpers.categoryColor(transaction.category);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      child: Column(
        children: [
          _ProgressHeader(
            currentIndex: currentIndex,
            totalCount: expenses.length,
          ),
          const SizedBox(height: 22),
          Expanded(
            child: _DiagonalSwipeCard(
              transaction: transaction,
              color: color,
              onMatch: () => onMatch(transaction),
              onMiss: () => onMiss(transaction),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onMiss(transaction),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Vibe Miss'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF9AA7B8),
                    side: const BorderSide(color: Color(0xFF9AA7B8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => onMatch(transaction),
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
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final int currentIndex;
  final int totalCount;

  const _ProgressHeader({required this.currentIndex, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0 ? 0.0 : (currentIndex + 1) / totalCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Harcamayı hisse çevir',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${currentIndex + 1}/$totalCount',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            color: AppColors.primarySoft,
            backgroundColor: Colors.white10,
          ),
        ),
      ],
    );
  }
}

class _DiagonalSwipeCard extends StatefulWidget {
  final TransactionEntity transaction;
  final Color color;
  final VoidCallback onMatch;
  final VoidCallback onMiss;

  const _DiagonalSwipeCard({
    required this.transaction,
    required this.color,
    required this.onMatch,
    required this.onMiss,
  });

  @override
  State<_DiagonalSwipeCard> createState() => _DiagonalSwipeCardState();
}

class _DiagonalSwipeCardState extends State<_DiagonalSwipeCard> {
  Offset _dragOffset = Offset.zero;

  void _reset() {
    setState(() => _dragOffset = Offset.zero);
  }

  void _finishDrag() {
    if (_dragOffset.dx > 110) {
      widget.onMatch();
      _reset();
      return;
    }

    if (_dragOffset.dx < -110) {
      widget.onMiss();
      _reset();
      return;
    }

    _reset();
  }

  @override
  Widget build(BuildContext context) {
    final rotation = (_dragOffset.dx / 320).clamp(-0.28, 0.28);
    final verticalLift = -(_dragOffset.dx.abs() * 0.22);
    final matchOpacity = (_dragOffset.dx / 140).clamp(0.0, 1.0);
    final missOpacity = (-_dragOffset.dx / 140).clamp(0.0, 1.0);

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 12,
          top: 28,
          child: Opacity(
            opacity: missOpacity,
            child: const _SwipeStamp(
              label: 'VIBE MISS',
              color: Color(0xFF9AA7B8),
              icon: Icons.close_rounded,
            ),
          ),
        ),
        Positioned(
          right: 12,
          top: 28,
          child: Opacity(
            opacity: matchOpacity,
            child: const _SwipeStamp(
              label: 'VIBE MATCH',
              color: Colors.greenAccent,
              icon: Icons.favorite_rounded,
            ),
          ),
        ),
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _dragOffset += details.delta;
            });
          },
          onPanEnd: (_) => _finishDrag(),
          child: AnimatedContainer(
            duration: _dragOffset == Offset.zero
                ? const Duration(milliseconds: 220)
                : Duration.zero,
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..translateByDouble(
                _dragOffset.dx,
                _dragOffset.dy + verticalLift,
                0,
                1,
              )
              ..rotateZ(rotation),
            child: SwipeCard(
              title: widget.transaction.title,
              amount: widget.transaction.amount.toStringAsFixed(2),
              icon: ExpenseViewHelpers.categoryIcon(
                widget.transaction.category,
              ),
              color: widget.color,
              description:
                  '${widget.transaction.category} harcaması. Beklentini karşıladıysa sağ üst çapraza, karşılamadıysa sol üst çapraza kaydır.',
            ),
          ),
        ),
      ],
    );
  }
}

class _SwipeStamp extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _SwipeStamp({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: color == Colors.greenAccent ? 0.15 : -0.15,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyzingView extends StatelessWidget {
  const _AnalyzingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 58,
              height: 58,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: AppColors.primarySoft,
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Ay sonu hikayen hesaplanıyor',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Vibe Match ve Vibe Miss kararların finansal karakterine dönüştürülüyor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryView extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final VoidCallback onRestart;

  const _StoryView({
    super.key,
    required this.transactions,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final report = _VibeCheckPageState._buildVibeReportUseCase(transactions);
    final expenses = transactions
        .where((transaction) => transaction.isExpense)
        .toList();
    final totalExpense = expenses.fold<double>(
      0,
      (total, transaction) => total + transaction.amount,
    );
    final topCategory = _topExpenseCategory(expenses);
    final topCategoryRatio = totalExpense == 0
        ? 0.0
        : topCategory.amount / totalExpense;

    return Column(
      children: [
        Expanded(
          child: PageView(
            children: [
              _StoryCard(
                color: AppColors.primarySoft,
                icon: Icons.auto_stories_rounded,
                title: 'Bu ayın finans hikayesi',
                value: report.persona,
                description:
                    'Harcama kararların bu ay seni böyle bir finansal karaktere dönüştürdü.',
              ),
              _StoryCard(
                color: ExpenseViewHelpers.categoryColor(topCategory.category),
                icon: ExpenseViewHelpers.categoryIcon(topCategory.category),
                title: 'Ayını en çok etkileyen alan',
                value: topCategory.category,
                description:
                    'Harcamalarının %${(topCategoryRatio * 100).round()} kısmı bu kategoriden geldi.',
              ),
              _StoryCard(
                color: Colors.greenAccent,
                icon: Icons.favorite_rounded,
                title: 'Seni mutlu eden harcamalar',
                value: '${report.matchedAmount.toStringAsFixed(2)} TL',
                description:
                    'Vibe Match olarak seçtiğin harcamalar değer yaratan tarafını gösteriyor.',
              ),
              _StoryCard(
                color: const Color(0xFF9AA7B8),
                icon: Icons.bolt_rounded,
                title: 'Potansiyel enerji',
                value: '${report.missedAmount.toStringAsFixed(2)} TL',
                description: report.roadmap,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: OutlinedButton.icon(
            onPressed: onRestart,
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('Başa Dön'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
      ],
    );
  }

  _TopCategory _topExpenseCategory(List<TransactionEntity> expenses) {
    if (expenses.isEmpty) {
      return const _TopCategory(category: 'Diğer', amount: 0);
    }

    final totals = <String, double>{};
    for (final expense in expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }

    final topEntry = totals.entries.reduce(
      (first, second) => first.value >= second.value ? first : second,
    );

    return _TopCategory(category: topEntry.key, amount: topEntry.value);
  }
}

class _TopCategory {
  final String category;
  final double amount;

  const _TopCategory({required this.category, required this.amount});
}

class _StoryCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final String description;

  const _StoryCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D24),
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 34),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
