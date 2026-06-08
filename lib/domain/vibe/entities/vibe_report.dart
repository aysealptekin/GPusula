import 'vibe_match.dart';

class VibeReport {
  final List<VibeMatch> matches;
  final double matchedAmount;
  final double missedAmount;
  final String persona;
  final String roadmap;

  const VibeReport({
    required this.matches,
    required this.matchedAmount,
    required this.missedAmount,
    required this.persona,
    required this.roadmap,
  });
}
