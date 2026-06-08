import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          onTap: onSeeAll,
          child: const Text(
            'Tümünü Gör',
            style: TextStyle(color: Color(0xFF7B8FF7)),
          ),
        ),
      ],
    );
  }
}
