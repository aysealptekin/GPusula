import '../../transaction/entities/transaction.dart';
import '../entities/vibe_match.dart';

class BuildVibeMatchesUseCase {
  const BuildVibeMatchesUseCase();

  List<VibeMatch> call(List<TransactionEntity> transactions) {
    final expenses = transactions
        .where(
          (transaction) => transaction.isExpense && transaction.isVibeMatch,
        )
        .toList();

    if (expenses.isEmpty) return const [];

    final totals = <String, double>{};
    for (final expense in expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }

    final totalExpense = totals.values.fold<double>(
      0,
      (total, amount) => total + amount,
    );

    final matches = totals.entries.map((entry) {
      final ratio = totalExpense == 0 ? 0.0 : entry.value / totalExpense;
      return VibeMatch(
        category: entry.key,
        title: _titleFor(entry.key, ratio),
        amount: entry.value,
        ratio: ratio,
        description: _descriptionFor(entry.key, entry.value, ratio),
      );
    }).toList();

    matches.sort((first, second) => second.amount.compareTo(first.amount));
    return matches;
  }

  String _titleFor(String category, double ratio) {
    if (ratio >= 0.45) return '$category senin değer alanın';
    if (ratio >= 0.25) return '$category sana iyi geliyor';
    return '$category küçük ama anlamlı';
  }

  String _descriptionFor(String category, double amount, double ratio) {
    final percentage = (ratio * 100).round();
    final formattedAmount = amount.toStringAsFixed(2);

    if (ratio >= 0.45) {
      return 'Vibe Match olarak işaretlediğin harcamaların içinde $category öne çıkıyor. $formattedAmount TL ile değer yaratan harcamalarının %$percentage kısmı burada.';
    }

    if (ratio >= 0.25) {
      return '$category harcamaları senin için karşılığını veren alanlardan biri. $formattedAmount TL ile matchlerinin %$percentage kısmını oluşturuyor.';
    }

    return '$category küçük ama olumlu bir sinyal. $formattedAmount TL, yani matchlerinin %$percentage kısmı.';
  }
}
