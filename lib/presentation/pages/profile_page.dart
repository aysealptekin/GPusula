import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

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
        //icerigin tasmasini engeller
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(), //private '_' method tanimladim
                const SizedBox(height: 24),
                _buildSectionTitle("Hesap"),
                const SizedBox(height: 12),
                _buildSettingsTile(
                  icon: Icons.edit_outlined,
                  title: "Profili Düzenle",
                  subtitle: "Kişisel bilgilerini güncelle",
                  color: const Color(0xFF7B8FF7),
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: "Bildirim Ayarları",
                  subtitle: "Hatırlatmaları ve uyarıları yönet",
                  color: Colors.orangeAccent,
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.palette_outlined,
                  title: "Tema Seçimi",
                  subtitle: "Uygulamanın görünümünü değiştir",
                  color: Colors.white,
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.lock_outline,
                  title: "Şifre Değiştir",
                  subtitle: "Hesabının güvenliğini güncelle",
                  color: Colors.lightBlueAccent,
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.changePassword,
                    );
                  },
                ),

                _buildSectionTitle("Veri Yönetimi"),
                const SizedBox(height: 12),
                _buildSettingsTile(
                  icon: Icons.delete_outline,
                  title: "Harcama Geçmişini Temizle",
                  subtitle: "Tüm işlem kayıtlarını sil",
                  color: Colors.redAccent,
                  onTap: () {
                    _showClearHistoryDialog(context);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.file_download_outlined,
                  title: "Verileri Dışa Aktar",
                  subtitle: "Harcamalarını rapor olarak al",
                  color: Colors.tealAccent,
                  onTap: () {},
                ),
                const SizedBox(height: 28),
                _buildDangerZone(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;

          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.homepage);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRoutes.adventure);
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, AppRoutes.pusulaAi);
          }
        },
        backgroundColor: const Color(0xFF0D0F14),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7B8FF7),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: "Anasayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: "Serüven",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_rounded),
            label: "Pusula AI",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF1F2430), Color(0xFF2B3242)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundImage: AssetImage('assets/merto1.png'),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mert",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "mert@gmail.com",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1618),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.redAccent.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text("Çıkış Yap"),
            ),
          ),
          SizedBox(height: 12), //HESABI SIL
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _ShowDeleteAccountDialog(context);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color.fromARGB(255, 75, 26, 26)),
                foregroundColor: const Color.fromARGB(255, 99, 19, 19),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.delete_forever_rounded),
              label: const Text("Hesabi sil"),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.alertbutton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Emin misin?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Tüm harcama geçmişin silinecek. Bu işlem geri alınamaz.",
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Vazgeç"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Sil",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  void _ShowDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.alertbutton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Hesabini silmek istiyor musun?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("vazgec"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              child: const Text(
                "hesabimi sil",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  //finansal ozet kismindaki containerlar icin
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
