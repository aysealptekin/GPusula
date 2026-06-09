import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../widgets/common/custom_bottom_nav.dart';

class PusulaAiPage extends StatelessWidget {
  const PusulaAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      appBar: AppBar(
        title: const Text('Pusula AI'),
        backgroundColor: AppColors.arkaplan,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D24),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PremiumBadge(),
                  SizedBox(height: 22),
                  Text(
                    'Pusula AI Premium',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bu özellik sadece premium kullanıcılar için aktiftir.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 24),
                  _PremiumFeature(
                    icon: Icons.psychology_alt_rounded,
                    text: 'Harcama alışkanlıklarına özel yorumlar',
                  ),
                  SizedBox(height: 10),
                  _PremiumFeature(
                    icon: Icons.auto_graph_rounded,
                    text: 'Vibe Match ve Miss kararlarından içgörü',
                  ),
                  SizedBox(height: 10),
                  _PremiumFeature(
                    icon: Icons.lock_rounded,
                    text: 'Premium üyelikle açılacak akıllı öneriler',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFBB92EE), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBB92EE).withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Icon(
        Icons.workspace_premium_rounded,
        color: Colors.white,
        size: 38,
      ),
    );
  }
}

class _PremiumFeature extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PremiumFeature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primarySoft, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, height: 1.3),
          ),
        ),
      ],
    );
  }
}
