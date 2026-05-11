import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../widgets/common/custom_bottom_nav.dart';
import '../widgets/profile/danger_zone.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/setting_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showFeatureNotReadyMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bu ozellik henuz hazir degil")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.arkaplan,
          appBar: AppBar(
            backgroundColor: AppColors.arkaplan,
            elevation: 0,
            title: const Text(
              "Profilim",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: 24),

                  const _SectionTitle("Hesap"),
                  const SizedBox(height: 12),

                  SettingsTile(
                    icon: Icons.edit_outlined,
                    title: "Profili Duzenle",
                    subtitle: "Kisisel bilgilerini guncelle",
                    color: const Color(0xFF7B8FF7),
                    onTap: () => _showFeatureNotReadyMessage(context),
                  ),
                  SettingsTile(
                    icon: Icons.lock_outline,
                    title: "Sifre Degistir",
                    subtitle: "Hesabinin guvenligini guncelle",
                    color: Colors.lightBlueAccent,
                    onTap: isLoading
                        ? () {}
                        : () => Navigator.pushNamed(
                            context,
                            AppRoutes.changePassword,
                          ),
                  ),

                  const SizedBox(height: 24),
                  const _SectionTitle("Veri Yonetimi"),
                  const SizedBox(height: 12),

                  SettingsTile(
                    icon: Icons.delete_outline,
                    title: "Harcama Gecmisini Temizle",
                    subtitle: "Tum islem kayitlarini sil",
                    color: Colors.redAccent,
                    onTap: () => _showFeatureNotReadyMessage(context),
                  ),

                  const SizedBox(height: 28),
                  DangerZone(
                    onLogout: isLoading
                        ? () {}
                        : () => context.read<AuthCubit>().logout(),
                    onDeleteAccount: () => _showFeatureNotReadyMessage(context),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
        );
      },
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
