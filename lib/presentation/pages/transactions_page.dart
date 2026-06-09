import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/transaction/entities/transaction.dart';
import '../cubit/expense/expense_cubit.dart';
import '../cubit/expense/expense_state.dart';
import '../widgets/add_expense/add_expense_sheet.dart';
import '../widgets/transactions/transaction_filter_bar.dart';
import '../widgets/transactions/transaction_list.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String? _selectedCategory;
  String _selectedType = 'all';
  String _selectedDateRange = 'all';
  String _selectedVibeStatus = 'all';
  String _searchText = '';
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

  void _showEditSheet(TransactionEntity transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddExpenseSheet(transaction: transaction),
      ),
    );
  }

  Future<void> _confirmDelete(TransactionEntity transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1D24),
          title: const Text(
            'İşlem silinsin mi?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            '${transaction.title} kaydı kalıcı olarak silinecek.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Sil',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final deleted = await context.read<ExpenseCubit>().deleteExpense(
      transaction.id,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(deleted ? 'İşlem silindi' : 'İşlem silinemedi'),
        backgroundColor: deleted ? AppColors.success : AppColors.error,
      ),
    );
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
              : <TransactionEntity>[];

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
              TransactionFilterBar(
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
              _TransactionSearchAndFilters(
                searchText: _searchText,
                selectedDateRange: _selectedDateRange,
                selectedVibeStatus: _selectedVibeStatus,
                onSearchChanged: (value) {
                  setState(() => _searchText = value);
                },
                onDateRangeChanged: (value) {
                  setState(() => _selectedDateRange = value);
                },
                onVibeStatusChanged: (value) {
                  setState(() => _selectedVibeStatus = value);
                },
              ),
              Expanded(
                child: TransactionList(
                  transactions: filteredTransactions,
                  onEdit: _showEditSheet,
                  onDelete: _confirmDelete,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<TransactionEntity> _filteredTransactions(
    List<TransactionEntity> transactions,
  ) {
    return transactions.where((transaction) {
      if (_selectedType == 'income' && !transaction.isIncome) return false;
      if (_selectedCategory != null &&
          (!transaction.isExpense ||
              transaction.category != _selectedCategory)) {
        return false;
      }

      if (!_matchesDateRange(transaction)) return false;
      if (!_matchesVibeStatus(transaction)) return false;

      final query = _searchText.trim().toLowerCase();
      if (query.isNotEmpty &&
          !transaction.title.toLowerCase().contains(query) &&
          !transaction.category.toLowerCase().contains(query)) {
        return false;
      }

      return true;
    }).toList();
  }

  bool _matchesDateRange(TransactionEntity transaction) {
    final now = DateTime.now();
    final createdAt = transaction.createdAt;

    switch (_selectedDateRange) {
      case '7days':
        return createdAt.isAfter(now.subtract(const Duration(days: 7)));
      case 'month':
        return createdAt.year == now.year && createdAt.month == now.month;
      case 'lastMonth':
        final lastMonth = DateTime(now.year, now.month - 1);
        return createdAt.year == lastMonth.year &&
            createdAt.month == lastMonth.month;
      default:
        return true;
    }
  }

  bool _matchesVibeStatus(TransactionEntity transaction) {
    switch (_selectedVibeStatus) {
      case 'match':
        return transaction.isVibeMatch;
      case 'miss':
        return transaction.isVibeMiss;
      case 'pending':
        return transaction.isExpense && transaction.isVibePending;
      default:
        return true;
    }
  }
}

class _TransactionSearchAndFilters extends StatelessWidget {
  final String searchText;
  final String selectedDateRange;
  final String selectedVibeStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onDateRangeChanged;
  final ValueChanged<String> onVibeStatusChanged;

  const _TransactionSearchAndFilters({
    required this.searchText,
    required this.selectedDateRange,
    required this.selectedVibeStatus,
    required this.onSearchChanged,
    required this.onDateRangeChanged,
    required this.onVibeStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        children: [
          TextField(
            onChanged: onSearchChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'İşlem veya kategori ara',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1A1D24),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _FilterDropdown(
                  value: selectedDateRange,
                  items: const {
                    'all': 'Tüm zamanlar',
                    '7days': 'Son 7 gün',
                    'month': 'Bu ay',
                    'lastMonth': 'Geçen ay',
                  },
                  onChanged: onDateRangeChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FilterDropdown(
                  value: selectedVibeStatus,
                  items: const {
                    'all': 'Tüm vibe',
                    'match': 'Match',
                    'miss': 'Miss',
                    'pending': 'Pending',
                  },
                  onChanged: onVibeStatusChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final Map<String, String> items;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: const Color(0xFF1A1D24),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1A1D24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 13),
      iconEnabledColor: Colors.white70,
      items: items.entries
          .map(
            (entry) =>
                DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
