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

  Future<void> _resetVibeHistory() async {
    final confirmed = await ProfileAccountDialogs.confirm(
      context: context,
      title: 'Vibe geçmişi sıfırlansın mı?',
      message:
          'Tüm Vibe Match ve Vibe Miss kararların yeniden beklemeye alınacak.',
      actionText: 'Sıfırla',
    );

    if (confirmed != true || !mounted) return;

    final succeeded = await context.read<ExpenseCubit>().resetVibeHistory();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          succeeded ? 'Vibe geçmişi sıfırlandı' : 'Vibe geçmişi sıfırlanamadı',
        ),
        backgroundColor: succeeded ? AppColors.success : AppColors.error,
      ),
    );
  }

  void _showVibeScheduleDialog() {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated
        ? authState.user.id
        : firebaseUser?.uid;
    if (userId == null) return;

    final profile = context.read<AccountCubit>().state.profile;
    var selectedDay = (profile?.vibeCheckDay ?? 28).clamp(1, 28).toInt();
    var selectedSecondDay = (profile?.vibeCheckSecondDay ?? 15)
        .clamp(1, 28)
        .toInt();
    var selectedFrequency = (profile?.vibeCheckFrequency ?? 1)
        .clamp(1, 2)
        .toInt();

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final hasDuplicateDays =
                selectedFrequency == 2 && selectedDay == selectedSecondDay;

            return AlertDialog(
              backgroundColor: const Color(0xFF1A1D24),
              title: const Text(
                'Vibe Check Gününü Değiştir',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      key: ValueKey('frequency-$selectedFrequency'),
                      initialValue: selectedFrequency,
                      dropdownColor: const Color(0xFF1A1D24),
                      decoration: const InputDecoration(
                        labelText: 'Sıklık',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('Ayda 1 kez')),
                        DropdownMenuItem(value: 2, child: Text('Ayda 2 kez')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedFrequency = value;
                            if (selectedFrequency == 2 &&
                                selectedDay == selectedSecondDay) {
                              selectedSecondDay = selectedDay == 28
                                  ? selectedDay - 1
                                  : selectedDay + 1;
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<int>(
                      key: ValueKey(
                        'first-day-$selectedDay-$selectedFrequency',
                      ),
                      initialValue: selectedDay,
                      dropdownColor: const Color(0xFF1A1D24),
                      decoration: const InputDecoration(
                        labelText: 'Gün',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: List.generate(
                        28,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}. gün'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => selectedDay = value);
                        }
                      },
                    ),
                    if (selectedFrequency == 2) ...[
                      const SizedBox(height: 14),
                      DropdownButtonFormField<int>(
                        key: ValueKey('second-day-$selectedSecondDay'),
                        initialValue: selectedSecondDay,
                        dropdownColor: const Color(0xFF1A1D24),
                        decoration: const InputDecoration(
                          labelText: 'İkinci gün',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        style: const TextStyle(color: Colors.white),
                        items: List.generate(
                          28,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1}. gün'),
                          ),
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => selectedSecondDay = value);
                          }
                        },
                      ),
                      if (hasDuplicateDays) ...[
                        const SizedBox(height: 8),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'İki kontrol günü aynı olamaz.',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Vazgeç'),
                ),
                TextButton(
                  onPressed: hasDuplicateDays
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);
                          final saved = await this.context
                              .read<AccountCubit>()
                              .updateVibeSchedule(
                                userId: userId,
                                day: selectedDay,
                                secondDay: selectedFrequency == 2
                                    ? selectedSecondDay
                                    : selectedDay,
                                frequency: selectedFrequency,
                              );
                          if (!mounted) return;
                          navigator.pop();
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                saved
                                    ? 'Vibe Check günü güncellendi'
                                    : 'Vibe Check günü güncellenemedi',
                              ),
                              backgroundColor: saved
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          );
                        },
                  child: const Text('Kaydet'),
                ),
              ],
            );
          },
        );
      },
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
                  onChangeVibeSchedule: _showVibeScheduleDialog,
                  onClearHistory: userId == null
                      ? () {}
                      : () => _clearTransactionHistory(userId),
                  onResetVibeHistory: _resetVibeHistory,
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
