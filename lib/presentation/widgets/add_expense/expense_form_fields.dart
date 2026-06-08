import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'İşlem adı',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ThousandsSeparatorInputFormatter(),
          ],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: '0 TL',
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

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      return const TextEditingValue();
    }

    final formatted = formatDigits(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String formatAmount(double amount) {
    return formatDigits(amount.round().toString());
  }

  static String formatDigits(String digits) {
    final cleanDigits = digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final buffer = StringBuffer();

    for (var i = 0; i < cleanDigits.length; i++) {
      final reverseIndex = cleanDigits.length - i;
      buffer.write(cleanDigits[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }
}
