import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class TransactionTypeSelector extends StatelessWidget {
  final String selectedType;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(
          value: 'expense',
          label: Text('Gider'),
          icon: Icon(Icons.remove_circle_outline),
        ),
        ButtonSegment(
          value: 'income',
          label: Text('Gelir'),
          icon: Icon(Icons.add_circle_outline),
        ),
      ],
      selected: {selectedType},
      onSelectionChanged: enabled
          ? (selection) => onChanged(selection.first)
          : null,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.black
              : Colors.white,
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primarySoft
              : Colors.white10,
        ),
      ),
    );
  }
}
