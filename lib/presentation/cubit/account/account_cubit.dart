import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/account/entities/user_profile.dart';
import '../../../domain/account/usecases/clear_transaction_history_usecase.dart';
import '../../../domain/account/usecases/delete_current_user_account_usecase.dart';
import '../../../domain/account/usecases/update_profile_usecase.dart';
import '../../../domain/account/usecases/update_vibe_schedule_usecase.dart';
import '../../../domain/account/usecases/watch_user_profile_usecase.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final WatchUserProfileUseCase watchUserProfileUseCase;
  final ClearTransactionHistoryUseCase clearTransactionHistoryUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdateVibeScheduleUseCase updateVibeScheduleUseCase;
  final DeleteCurrentUserAccountUseCase deleteCurrentUserAccountUseCase;

  StreamSubscription<UserProfile?>? _profileSubscription;
  String? _userId;

  AccountCubit({
    required this.watchUserProfileUseCase,
    required this.clearTransactionHistoryUseCase,
    required this.updateProfileUseCase,
    required this.updateVibeScheduleUseCase,
    required this.deleteCurrentUserAccountUseCase,
  }) : super(const AccountState.initial());

  void watchUserProfile(String userId) {
    if (_userId == userId && _profileSubscription != null) return;

    _userId = userId;
    emit(state.copyWith(isLoading: true, clearError: true));
    _profileSubscription?.cancel();
    _profileSubscription = watchUserProfileUseCase(userId).listen(
      (profile) {
        emit(
          state.copyWith(profile: profile, isLoading: false, clearError: true),
        );
      },
      onError: (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
      },
    );
  }

  Future<bool> clearTransactionHistory(String userId) {
    return _runAction(() => clearTransactionHistoryUseCase(userId));
  }

  Future<bool> updateProfile({
    required String userId,
    required String name,
    required String email,
    List<int>? photoBytes,
  }) {
    return _runAction(
      () => updateProfileUseCase(
        userId: userId,
        name: name,
        email: email,
        photoBytes: photoBytes,
      ),
    );
  }

  Future<bool> updateVibeSchedule({
    required String userId,
    required int day,
    required int secondDay,
    required int frequency,
  }) {
    return _runAction(
      () => updateVibeScheduleUseCase(
        userId: userId,
        day: day,
        secondDay: secondDay,
        frequency: frequency,
      ),
    );
  }

  Future<bool> deleteCurrentUserAccount({required String password}) {
    return _runAction(
      () => deleteCurrentUserAccountUseCase(password: password),
    );
  }

  void clear() {
    _profileSubscription?.cancel();
    _profileSubscription = null;
    _userId = null;
    emit(const AccountState.initial());
  }

  Future<bool> _runAction(Future<void> Function() action) async {
    emit(state.copyWith(isBusy: true, clearError: true));

    try {
      await action();
      emit(state.copyWith(isBusy: false, clearError: true));
      return true;
    } catch (error) {
      emit(state.copyWith(isBusy: false, errorMessage: error.toString()));
      return false;
    }
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}
