import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/transaction_model.dart';
import '../../cubit/expense/expense_cubit.dart';
import '../../cubit/expense/expense_state.dart';
import 'expense_save_button.dart';
import 'expense_category_selector.dart';
import 'expense_form_fields.dart';
import 'transaction_type_selector.dart';

class AddExpenseSheet extends StatefulWidget {
  final TransactionModel? transaction;

  const AddExpenseSheet({super.key, this.transaction});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Yemek';
  String _selectedType = 'expense';

  bool get _isEditing => widget.transaction != null;

  bool get _isIncome => _selectedType == 'income';

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;
    if (transaction == null) return;

    _nameController.text = transaction.title;
    _amountController.text = ThousandsSeparatorInputFormatter.formatAmount(
      transaction.amount,
    );
    _selectedType = transaction.type;
    _selectedCategory = transaction.isIncome ? 'Yemek' : transaction.category;
  }

  Future<void> _saveExpense() async {
    final title = _nameController.text.trim();
    final amountText = _amountController.text.trim().replaceAll(',', '');
    final amount = double.tryParse(amountText);

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('İşlem adı ve geçerli bir tutar gir'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final category = _isIncome ? 'Gelir' : _selectedCategory;
    final cubit = context.read<ExpenseCubit>();
    final saved = _isEditing
        ? await cubit.updateExpense(
            expenseId: widget.transaction!.id,
            title: title,
            amount: amount,
            category: category,
            type: _selectedType,
          )
        : await cubit.addExpense(
            title: title,
            amount: amount,
            category: category,
            type: _selectedType,
          );

    if (!mounted) return;

    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'İşlem güncellenemedi' : 'İşlem kaydedilemedi',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'İşlem güncellendi' : _successMessage()),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _successMessage() {
    return _isIncome ? 'Gelir başarıyla eklendi' : 'Harcama başarıyla eklendi';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        final isSaving = state is ExpenseLoaded && state.isSaving;

        return Container(
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            color: AppColors.bgDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing
                    ? 'İşlemi Düzenle'
                    : _isIncome
                    ? 'Gelir Detayı'
                    : 'Harcama Detayı',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TransactionTypeSelector(
                selectedType: _selectedType,
                enabled: !isSaving,
                onChanged: (type) => setState(() => _selectedType = type),
              ),
              const SizedBox(height: 25),
              if (!_isIncome)
                ExpenseCategorySelector(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: isSaving
                      ? (_) {}
                      : (category) =>
                            setState(() => _selectedCategory = category),
                ),
              if (!_isIncome) const SizedBox(height: 25),
              ExpenseFormFields(
                nameController: _nameController,
                amountController: _amountController,
              ),
              const SizedBox(height: 30),
              ExpenseSaveButton(
                isSaving: isSaving,
                isEditing: _isEditing,
                isIncome: _isIncome,
                onPressed: _saveExpense,
              ),
            ],
          ),
        );
      },
    );
  }
}
