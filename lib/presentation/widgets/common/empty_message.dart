import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  final String message;

  const EmptyMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
