import 'package:flutter/material.dart';

import '../../helpers/expense_view_helpers.dart';

class TransactionFilterBar extends StatelessWidget {
  final String selectedType;
  final String? selectedCategory;
  final VoidCallback onAllSelected;
  final VoidCallback onIncomeSelected;
  final ValueChanged<String> onCategorySelected;

  const TransactionFilterBar({
    super.key,
    required this.selectedType,
    required this.selectedCategory,
    required this.onAllSelected,
    required this.onIncomeSelected,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          _FilterChipButton(
            label: 'Tümü',
            selected: selectedType == 'all',
            icon: Icons.all_inclusive_rounded,
            color: const Color(0xFF7B8FF7),
            onSelected: onAllSelected,
          ),
          _FilterChipButton(
            label: 'Gelenler',
            selected: selectedType == 'income',
            icon: Icons.payments_rounded,
            color: Colors.greenAccent,
            onSelected: onIncomeSelected,
          ),
          ...ExpenseViewHelpers.expenseCategories.map(
            (category) => _FilterChipButton(
              label: category,
              selected:
                  selectedType == 'expense' && selectedCategory == category,
              icon: ExpenseViewHelpers.categoryIcon(category),
              color: ExpenseViewHelpers.categoryColor(category),
              onSelected: () => onCategorySelected(category),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData icon;
  final Color color;
  final VoidCallback onSelected;

  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.icon,
    required this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: Icon(icon, size: 18, color: selected ? Colors.black : color),
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: const Color(0xFF7B8FF7),
        backgroundColor: const Color(0xFF1A1D24),
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(
          color: selected ? const Color(0xFF7B8FF7) : Colors.white12,
        ),
      ),
    );
  }
}
