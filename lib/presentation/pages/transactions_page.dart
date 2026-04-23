import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      appBar: AppBar(title: const Text("Tüm İşlemler")),
      body: const Center(child: Text("Tüm işlemler burada")),
    );
  }
}
