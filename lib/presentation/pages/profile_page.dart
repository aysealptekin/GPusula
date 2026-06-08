import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/account/entities/user_profile.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../cubit/account/account_cubit.dart';
import '../cubit/account/account_state.dart';
import '../cubit/expense/expense_cubit.dart';
import '../widgets/common/custom_bottom_nav.dart';
import '../widgets/profile/edit_profile_sheet.dart';
import '../widgets/profile/profile_account_dialogs.dart';
import '../widgets/profile/profile_settings_list.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _clearTransactionHistory(String userId) async {
    final confirmed = await ProfileAccountDialogs.confirm(
      context: context,
      title: 'Harcama geçmişi silinsin mi?',
      message: 'Tüm işlem kayıtların kalıcı olarak silinecek.',
      actionText: 'Temizle',
    );

    if (confirmed != true || !mounted) return;

    await _runAccountAction(
      action: () =>
          context.read<AccountCubit>().clearTransactionHistory(userId),
      successMessage: 'Harcama geçmişi temizlendi',
    );
  }

  Future<void> _deleteAccount() async {
    final password = await ProfileAccountDialogs.askPasswordForDelete(context);
    if (password == null || !mounted) return;

    await _runAccountAction(
      action: () => context.read<AccountCubit>().deleteCurrentUserAccount(
        password: password,
      ),
      successMessage: 'Hesap silindi',
      onSuccess: () {
        context.read<ExpenseCubit>().clear();
        context.read<AccountCubit>().clear();
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      },
    );
  }

  void _showEditProfileSheet({
    required String userId,
    required String name,
    required String email,
    required String? photoUrl,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditProfileSheet(
          name: name,
          email: email,
          photoUrl: photoUrl,
          onSave: (updatedName, photoBytes) => _updateProfile(
            userId: userId,
            name: updatedName,
            email: email,
            photoBytes: photoBytes,
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile({
    required String userId,
    required String name,
    required String email,
    required List<int>? photoBytes,
  }) async {
    await _runAccountAction(
      action: () => context.read<AccountCubit>().updateProfile(
        userId: userId,
        name: name,
        email: email,
        photoBytes: photoBytes,
      ),
      successMessage: 'Profil güncellendi',
      onSuccess: () => context.read<AuthCubit>().updateCurrentUserName(name),
    );
  }

  Future<void> _logout() async {
    context.read<ExpenseCubit>().clear();
    context.read<AccountCubit>().clear();
    await context.read<AuthCubit>().logout();
  }

  Future<void> _runAccountAction({
    required Future<bool> Function() action,
    required String successMessage,
    VoidCallback? onSuccess,
  }) async {
    final succeeded = await action();
    if (!mounted) return;

    if (!succeeded) {
      final message =
          context.read<AccountCubit>().state.errorMessage ??
          'İşlem tamamlanamadı';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successMessage),
        backgroundColor: AppColors.success,
      ),
    );
    onSuccess?.call();
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
        final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
        final userId = state is Authenticated
            ? state.user.id
            : firebaseUser?.uid;

        if (userId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.read<AccountCubit>().watchUserProfile(userId);
            }
          });
        }

        return BlocBuilder<AccountCubit, AccountState>(
          builder: (context, accountState) {
            final profile = accountState.profile;
            final name = _profileName(state, firebaseUser, profile);
            final email = _profileEmail(state, firebaseUser, profile);
            final photoUrl = _profilePhotoUrl(firebaseUser, profile);

            return Scaffold(
              backgroundColor: AppColors.arkaplan,
              appBar: AppBar(
                backgroundColor: AppColors.arkaplan,
                elevation: 0,
                title: const Text(
                  'Profilim',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
              body: SafeArea(
                child: ProfileSettingsList(
                  userName: name,
                  email: email,
                  photoUrl: photoUrl,
                  onEditProfile: userId == null
                      ? () {}
                      : () => _showEditProfileSheet(
                          userId: userId,
                          name: name,
                          email: email,
                          photoUrl: photoUrl,
                        ),
                  onChangePassword: () =>
                      Navigator.pushNamed(context, AppRoutes.changePassword),
                  onClearHistory: userId == null
                      ? () {}
                      : () => _clearTransactionHistory(userId),
                  onLogout: _logout,
                  onDeleteAccount: _deleteAccount,
                ),
              ),
              bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
            );
          },
        );
      },
    );
  }

  String _profileName(
    AuthState state,
    firebase_auth.User? firebaseUser,
    UserProfile? profile,
  ) {
    final name =
        profile?.name ??
        (state is Authenticated ? state.user.name : null) ??
        firebaseUser?.displayName ??
        firebaseUser?.email?.split('@').first;

    return (name == null || name.trim().isEmpty) ? 'Kullanıcı' : name.trim();
  }

  String _profileEmail(
    AuthState state,
    firebase_auth.User? firebaseUser,
    UserProfile? profile,
  ) {
    return profile?.email ??
        (state is Authenticated ? state.user.email : null) ??
        firebaseUser?.email ??
        '';
  }

  String? _profilePhotoUrl(
    firebase_auth.User? firebaseUser,
    UserProfile? profile,
  ) {
    return profile?.photoUrl ?? firebaseUser?.photoURL;
  }
}
