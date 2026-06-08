import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ExpenseCategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Yemek', 'icon': Icons.restaurant},
    {'name': 'Market', 'icon': Icons.shopping_cart},
    {'name': 'Ulaşım', 'icon': Icons.directions_bus},
    {'name': 'Eğlence', 'icon': Icons.confirmation_number},
    {'name': 'Diğer', 'icon': Icons.more_horiz},
  ];

  const ExpenseCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory == cat['name'];

          return GestureDetector(
            onTap: () => onCategorySelected(cat['name'] as String),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primarySoft : Colors.white10,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    cat['name'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
