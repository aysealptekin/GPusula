import '../../transaction/entities/transaction.dart';
import '../entities/vibe_report.dart';
import 'build_vibe_matches_usecase.dart';

class BuildVibeReportUseCase {
  final BuildVibeMatchesUseCase buildVibeMatchesUseCase;

  const BuildVibeReportUseCase({
    this.buildVibeMatchesUseCase = const BuildVibeMatchesUseCase(),
  });

  VibeReport call(List<TransactionEntity> transactions) {
    final matches = buildVibeMatchesUseCase(transactions);
    final matchedAmount = transactions
        .where(
          (transaction) => transaction.isExpense && transaction.isVibeMatch,
        )
        .fold<double>(0, (total, transaction) => total + transaction.amount);
    final missedAmount = transactions
        .where((transaction) => transaction.isExpense && transaction.isVibeMiss)
        .fold<double>(0, (total, transaction) => total + transaction.amount);

    final topCategory = matches.isEmpty ? null : matches.first.category;

    return VibeReport(
      matches: matches,
      matchedAmount: matchedAmount,
      missedAmount: missedAmount,
      persona: _personaFor(topCategory),
      roadmap: _roadmapFor(missedAmount),
    );
  }

  String _personaFor(String? topCategory) {
    switch (topCategory) {
      case 'Yemek':
        return 'Sosyal Lezzet Kaşifi';
      case 'Market':
        return 'Günlük Planlayıcı';
      case 'Ulaşım':
        return 'Şehir Rotacısı';
      case 'Eğlence':
        return 'Deneyim Avcısı';
      default:
        return 'Dengeli Kaşif';
    }
  }

  String _roadmapFor(double missedAmount) {
    if (missedAmount <= 0) {
      return 'Henüz Vibe Miss yok. Harcamalarını değerlendirdikçe potansiyel enerji alanın oluşacak.';
    }

    return '${missedAmount.toStringAsFixed(2)} TL potansiyel enerji var. Bu tutarı birikim hedeflerine veya kategori limitlerine yönlendirebilirsin.';
  }
}
