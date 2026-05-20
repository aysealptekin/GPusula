import 'package:flutter/material.dart';

class DangerZone extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  const DangerZone({
    super.key,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1618),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          _buildDangerButton(
            icon: Icons.logout_rounded,
            label: "Cikis Yap",
            onPressed: onLogout,
          ),
          const SizedBox(height: 12),
          _buildDangerButton(
            icon: Icons.delete_forever_rounded,
            label: "Hesabi Sil",
            onPressed: onDeleteAccount,
          ),
        ],
      ),
    );
  }

  Widget _buildDangerButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.redAccent),
          foregroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
