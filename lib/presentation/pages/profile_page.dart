import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/settings_tile.dart';
import '../widgets/profile/danger_zone.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      appBar: AppBar(
        backgroundColor: AppColors.arkaplan,
        elevation: 0,
        title: const Text("Profilim", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(), // 1
              const SizedBox(height: 24),
              
              const _SectionTitle("Hesap"), 
              const SizedBox(height: 12),
              
              SettingsTile(
                icon: Icons.edit_outlined,
                title: "Profili Düzenle",
                subtitle: "Kişisel bilgilerini güncelle",
                color: const Color(0xFF7B8FF7),
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.lock_outline,
                title: "Şifre Değiştir",
                subtitle: "Hesabının güvenliğini güncelle",
                color: Colors.lightBlueAccent,
                onTap: () => Navigator.pushNamed(context, AppRoutes.changePassword),
              ),

              const SizedBox(height: 24),
              const _SectionTitle("Veri Yönetimi"),
              const SizedBox(height: 12),

              SettingsTile(
                icon: Icons.delete_outline,
                title: "Harcama Geçmişini Temizle",
                subtitle: "Tüm işlem kayıtlarını sil",
                color: Colors.redAccent,
                onTap: () {},
              ),

              const SizedBox(height: 28),
              const DangerZone(), // 3
            ],
          ),
        ),
      ),
      // BottomNavigationBar kodun buraya gelecek (Aynen kalsın)
    );
  }
}

// Sayfa içindeki küçük başlıklar için basit bir widget
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}