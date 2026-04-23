import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      appBar: AppBar(title: const Text("Kategoriler")),
      body: const Center(child: Text("Tüm kategoriler burada")),
    );
  }
}
