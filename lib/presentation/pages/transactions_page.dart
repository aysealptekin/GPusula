import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/transaction_model.dart';
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

  void _showEditSheet(TransactionModel transaction) {
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

  Future<void> _confirmDelete(TransactionModel transaction) async {
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
              : <TransactionModel>[];

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

  List<TransactionModel> _filteredTransactions(
    List<TransactionModel> transactions,
  ) {
    if (_selectedType == 'income') {
      return transactions.where((transaction) => transaction.isIncome).toList();
    }

    if (_selectedCategory != null) {
      return transactions
          .where(
            (transaction) =>
                transaction.isExpense &&
                transaction.category == _selectedCategory,
          )
          .toList();
    }

    return transactions;
  }
}
