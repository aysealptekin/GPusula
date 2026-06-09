import 'package:flutter/material.dart';

import 'savings_goal_view_data.dart';

class GoalCard extends StatelessWidget {
  final SavingsGoalViewData goal;
  final VoidCallback onTap;

  const GoalCard({super.key, required this.goal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1A1D24),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(goal.icon, color: goal.color, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      goal.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '%${(goal.progress.clamp(0, 1) * 100).toStringAsFixed(0)}',
                    style: TextStyle(
                      color: goal.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.edit_rounded, color: Colors.white38, size: 18),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: goal.progress.clamp(0.0, 1.0).toDouble(),
                  backgroundColor: Colors.white10,
                  color: goal.color,
                  minHeight: 7,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _GoalMetric(
                      label: 'Hedef',
                      value: '${goal.targetAmount.toStringAsFixed(0)} TL',
                    ),
                  ),
                  Expanded(
                    child: _GoalMetric(
                      label: 'Aktarılan',
                      value: '${goal.savedAmount.toStringAsFixed(0)} TL',
                    ),
                  ),
                  Expanded(
                    child: _GoalMetric(
                      label: 'Kalan',
                      value: '${goal.remainingAmount.toStringAsFixed(0)} TL',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalMetric extends StatelessWidget {
  final String label;
  final String value;

  const _GoalMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
