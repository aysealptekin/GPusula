import 'package:flutter/material.dart';

class HomeBalanceCard extends StatelessWidget {
  final double totalAmount;

  const HomeBalanceCard({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Toplam Harcama',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            '${totalAmount.toStringAsFixed(2)} TL',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.show_chart, color: Colors.white38, size: 35),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Harcamalarında %80 oraninda artis gozlemlendi',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
