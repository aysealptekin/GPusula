import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
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
  String _selectedCategory = "Yemek";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Kutunun karemsi ve kısa olmasını sağlar
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Harcama Detayı",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),

          // 1. Kategoriler
          ExpenseCategorySelector(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) =>
                setState(() => _selectedCategory = category),
          ),

          const SizedBox(height: 25),

          // 2. Yazı Alanları
          ExpenseFormFields(
            nameController: _nameController,
            amountController: _amountController,
          ),

          const SizedBox(height: 30),

          // 3. Artı Butonu
          ElevatedButton(
            onPressed: () {
              // Buraya harcamayı kaydetme kodu gelecek
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Harcama Başarıyla Eklendi!"),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primarySoft,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Icon(Icons.add, size: 35, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
