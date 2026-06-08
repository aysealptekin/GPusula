import '../../../domain/account/entities/user_profile.dart';

class AccountState {
  final UserProfile? profile;
  final bool isLoading;
  final bool isBusy;
  final String? errorMessage;

  const AccountState({
    this.profile,
    this.isLoading = false,
    this.isBusy = false,
    this.errorMessage,
  });

  const AccountState.initial() : this();

  AccountState copyWith({
    UserProfile? profile,
    bool? isLoading,
    bool? isBusy,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AccountState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
