import 'package:flutter/material.dart';

import 'goal_card.dart';

class HomeGoalsSection extends StatelessWidget {
  const HomeGoalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Birikim Hedefleri',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: GoalCard(
                title: 'Tasarruf',
                amount: '12,500 TL',
                progress: 0.72,
                icon: Icons.wallet,
                color: Colors.pinkAccent,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: GoalCard(
                title: 'Tatil',
                amount: '8,200 TL',
                progress: 0.45,
                icon: Icons.flight,
                color: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
