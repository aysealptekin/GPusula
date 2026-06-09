import 'package:flutter/material.dart';

import 'danger_zone.dart';
import 'profile_header.dart';
import 'setting_tile.dart';

class ProfileSettingsList extends StatelessWidget {
  final String userName;
  final String email;
  final String? photoUrl;
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onChangeVibeSchedule;
  final VoidCallback onClearHistory;
  final VoidCallback onResetVibeHistory;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  const ProfileSettingsList({
    super.key,
    required this.userName,
    required this.email,
    this.photoUrl,
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onChangeVibeSchedule,
    required this.onClearHistory,
    required this.onResetVibeHistory,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(userName: userName, email: email, photoUrl: photoUrl),
          const SizedBox(height: 24),
          const _SectionTitle('Hesap'),
          const SizedBox(height: 12),
          SettingsTile(
            icon: Icons.edit_outlined,
            title: 'Profili Düzenle',
            subtitle: 'Kişisel bilgilerini güncelle',
            color: const Color(0xFF7B8FF7),
            onTap: onEditProfile,
          ),
          SettingsTile(
            icon: Icons.lock_outline,
            title: 'Şifre Değiştir',
            subtitle: 'Hesabının güvenliğini güncelle',
            color: Colors.lightBlueAccent,
            onTap: onChangePassword,
          ),
          SettingsTile(
            icon: Icons.event_repeat_rounded,
            title: 'Vibe Check Gününü Değiştir',
            subtitle: 'Aylık Vibe Check tarihini ve sıklığını seç',
            color: Colors.amberAccent,
            onTap: onChangeVibeSchedule,
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Veri Yönetimi'),
          const SizedBox(height: 12),
          SettingsTile(
            icon: Icons.restart_alt_rounded,
            title: 'Vibe Geçmişini Sıfırla',
            subtitle: 'Match/Miss kararlarını yeniden değerlendir',
            color: Colors.orangeAccent,
            onTap: onResetVibeHistory,
          ),
          SettingsTile(
            icon: Icons.delete_outline,
            title: 'Harcama Geçmişini Temizle',
            subtitle: 'Tüm işlem kayıtlarını sil',
            color: Colors.redAccent,
            onTap: onClearHistory,
          ),
          const SizedBox(height: 28),
          DangerZone(onLogout: onLogout, onDeleteAccount: onDeleteAccount),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
