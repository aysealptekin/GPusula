import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../cubit/expense/expense_cubit.dart';
import '../../cubit/expense/expense_state.dart';
import 'expense_category_selector.dart';
import 'expense_form_fields.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Yemek';
  String _selectedType = 'expense';

  bool get _isIncome => _selectedType == 'income';

  Future<void> _saveExpense() async {
    final title = _nameController.text.trim();
    final amountText = _amountController.text.trim().replaceAll(',', '.');
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

    final saved = await context.read<ExpenseCubit>().addExpense(
      title: title,
      amount: amount,
      category: _isIncome ? 'Gelir' : _selectedCategory,
      type: _selectedType,
    );

    if (!mounted) return;

    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('İşlem kaydedilemedi'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isIncome ? 'Gelir başarıyla eklendi' : 'Harcama başarıyla eklendi'),
        backgroundColor: AppColors.success,
      ),
    );
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
                _isIncome ? 'Gelir Detayı' : 'Harcama Detayı',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'expense',
                    label: Text('Gider'),
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  ButtonSegment(
                    value: 'income',
                    label: Text('Gelir'),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: isSaving
                    ? null
                    : (selection) {
                        setState(() => _selectedType = selection.first);
                      },
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? Colors.black
                        : Colors.white,
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? AppColors.primarySoft
                        : Colors.white10,
                  ),
                ),
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
              ElevatedButton(
                onPressed: isSaving ? null : _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarySoft,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Icon(
                        _isIncome ? Icons.add_circle_outline : Icons.add,
                        size: 35,
                        color: Colors.black,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
