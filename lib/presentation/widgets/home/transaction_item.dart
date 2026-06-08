import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final IconData icon;
  final Color color;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TransactionItem({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.icon,
    required this.color,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amount.startsWith('-')
                  ? Colors.redAccent
                  : Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );

    if (onDelete == null && onEdit == null) return content;

    return Dismissible(
      key: ValueKey('$title-$date-$amount'),
      direction: DismissDirection.horizontal,
      dismissThresholds: const {
        DismissDirection.startToEnd: 0.25,
        DismissDirection.endToStart: 0.25,
      },
      confirmDismiss: (direction) async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (direction == DismissDirection.startToEnd) {
            onEdit?.call();
          } else if (direction == DismissDirection.endToStart) {
            onDelete?.call();
          }
        });
        return false;
      },
      background: _SwipeActionBackground(
        alignment: Alignment.centerLeft,
        icon: Icons.edit_outlined,
        label: 'Düzenle',
        color: const Color(0xFF7B8FF7),
      ),
      secondaryBackground: const _SwipeActionBackground(
        alignment: Alignment.centerRight,
        icon: Icons.delete_outline,
        label: 'Sil',
        color: Colors.redAccent,
      ),
      child: content,
    );
  }
}

class _SwipeActionBackground extends StatelessWidget {
  final Alignment alignment;
  final IconData icon;
  final String label;
  final Color color;

  const _SwipeActionBackground({
    required this.alignment,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: content,
    );
  }
}
