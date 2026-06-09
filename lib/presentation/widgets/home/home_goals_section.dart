import 'package:flutter/material.dart';

import 'goal_card.dart';
import 'savings_goal_view_data.dart';

class HomeGoalsSection extends StatelessWidget {
  final List<SavingsGoalViewData> goals;
  final ValueChanged<int> onGoalTap;

  const HomeGoalsSection({
    super.key,
    required this.goals,
    required this.onGoalTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Birikim Hedefleri',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        if (goals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D24),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white10),
            ),
            child: const Row(
              children: [
                Icon(Icons.savings_rounded, color: Colors.white38),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Henüz birikim hedefi eklemedin.',
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
              ],
            ),
          )
        else
          ...goals.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GoalCard(
                goal: entry.value,
                onTap: () => onGoalTap(entry.key),
              ),
            ),
          ),
      ],
    );
  }
}
