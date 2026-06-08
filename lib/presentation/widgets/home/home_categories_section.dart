import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../helpers/expense_view_helpers.dart';
import '../common/empty_message.dart';
import 'budget_category_card.dart';
import 'home_section_header.dart';

class HomeCategoriesSection extends StatelessWidget {
  final double totalExpense;
  final Map<String, double> categoryTotals;

  const HomeCategoriesSection({
    super.key,
    required this.totalExpense,
    required this.categoryTotals,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeSectionHeader(
          title: 'Kategoriler',
          onSeeAll: () => Navigator.pushNamed(context, AppRoutes.categories),
        ),
        const SizedBox(height: 15),
        if (categoryTotals.isEmpty)
          const EmptyMessage(message: 'Kategori özeti için harcama ekle')
        else
          ...categoryTotals.entries.map(
            (entry) => BudgetCategoryCard(
              title: entry.key,
              amount: '${entry.value.toStringAsFixed(2)} TL',
              progress: totalExpense == 0
                  ? 0
                  : (entry.value / totalExpense).clamp(0.0, 1.0).toDouble(),
              status: 'GİDER',
              statusColor: ExpenseViewHelpers.categoryColor(entry.key),
              icon: ExpenseViewHelpers.categoryIcon(entry.key),
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.transactions,
                arguments: entry.key,
              ),
            ),
          ),
      ],
    );
  }
}
