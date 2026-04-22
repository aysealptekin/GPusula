import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      appBar: AppBar(title: const Text("Tüm İşlemler")),
      body: const Center(child: Text("Tüm işlemler burada")),
    );
  }
}
