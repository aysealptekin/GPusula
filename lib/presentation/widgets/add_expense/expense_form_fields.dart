import 'package:flutter/material.dart';

class ExpenseFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController amountController;

  const ExpenseFormFields({
    super.key,
    required this.nameController,
    required this.amountController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // İsim Kutusu
        TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Harcama İsmi (Örn: Akşam Yemeği)",
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 15),
        // Miktar Kutusu
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: "0.00 ₺",
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIcon: const Icon(
              Icons.currency_lira,
              color: Colors.greenAccent,
            ),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
