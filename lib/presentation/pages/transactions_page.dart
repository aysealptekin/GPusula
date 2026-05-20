import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/expense/entities/expense.dart';
import '../cubit/expense/expense_cubit.dart';
import '../cubit/expense/expense_state.dart';
import '../helpers/expense_view_helpers.dart';
import '../widgets/home/transaction_item.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String? _selectedCategory;
  String _selectedType = 'all';
  bool _initializedFromRoute = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initializedFromRoute) return;

    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is String && arguments.isNotEmpty) {
      _selectedCategory = arguments;
      _selectedType = 'expense';
    }
    _initializedFromRoute = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      appBar: AppBar(
        title: const Text('Tüm İşlemler'),
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

          if (transactions.isEmpty) {
            return const Center(
              child: Text(
                'Henüz işlem eklenmedi',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final filteredTransactions = _filteredTransactions(transactions);

          return Column(
            children: [
              _CategoryFilterBar(
                selectedType: _selectedType,
                selectedCategory: _selectedCategory,
                onAllSelected: () {
                  setState(() {
                    _selectedType = 'all';
                    _selectedCategory = null;
                  });
                },
                onIncomeSelected: () {
                  setState(() {
                    _selectedType = 'income';
                    _selectedCategory = null;
                  });
                },
                onCategorySelected: (category) {
                  setState(() {
                    _selectedType = 'expense';
                    _selectedCategory = category;
                  });
                },
              ),
              Expanded(
                child: filteredTransactions.isEmpty
                    ? const Center(
                        child: Text(
                          'Bu filtrede işlem yok',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];
                          return TransactionItem(
                            title: transaction.title,
                            date: ExpenseViewHelpers.formatDate(
                              transaction.createdAt,
                            ),
                            amount: ExpenseViewHelpers.signedAmount(
                              transaction,
                            ),
                            icon: ExpenseViewHelpers.categoryIcon(
                              transaction.category,
                            ),
                            color: ExpenseViewHelpers.categoryColor(
                              transaction.category,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Expense> _filteredTransactions(List<Expense> transactions) {
    if (_selectedType == 'income') {
      return transactions.where((transaction) => transaction.isIncome).toList();
    }

    if (_selectedCategory != null) {
      return transactions
          .where(
            (transaction) =>
                transaction.isExpense && transaction.category == _selectedCategory,
          )
          .toList();
    }

    return transactions;
  }
}

class _CategoryFilterBar extends StatelessWidget {
  final String selectedType;
  final String? selectedCategory;
  final VoidCallback onAllSelected;
  final VoidCallback onIncomeSelected;
  final ValueChanged<String> onCategorySelected;

  const _CategoryFilterBar({
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
