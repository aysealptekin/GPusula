import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/account/repositories/account_repository_impl.dart';
import '../../data/auth/datasources/auth_remote_datasource.dart';
import '../../data/auth/repositories/auth_repository_impl.dart';
import '../../data/services/account_service.dart';
import '../../data/services/transaction_service.dart';
import '../../data/transaction/repositories/transaction_repository_impl.dart';
import '../../domain/account/usecases/clear_transaction_history_usecase.dart';
import '../../domain/account/usecases/delete_current_user_account_usecase.dart';
import '../../domain/account/usecases/update_profile_usecase.dart';
import '../../domain/account/usecases/update_vibe_schedule_usecase.dart';
import '../../domain/account/usecases/watch_user_profile_usecase.dart';
import '../../domain/auth/usecases/change_password_usecase.dart';
import '../../domain/auth/usecases/login_usecase.dart';
import '../../domain/auth/usecases/logout_usecase.dart';
import '../../domain/auth/usecases/register_usecase.dart';
import '../../domain/auth/usecases/reset_password_usecase.dart';
import '../../domain/auth/usecases/sign_in_with_google_usecase.dart';
import '../../domain/transaction/usecases/add_transaction_usecase.dart';
import '../../domain/transaction/usecases/delete_transaction_usecase.dart';
import '../../domain/transaction/usecases/reset_vibe_statuses_usecase.dart';
import '../../domain/transaction/usecases/update_transaction_usecase.dart';
import '../../domain/transaction/usecases/update_vibe_status_usecase.dart';
import '../../domain/transaction/usecases/watch_transactions_usecase.dart';
import '../../presentation/bloc/auth_cubit.dart';
import '../../presentation/cubit/account/account_cubit.dart';
import '../../presentation/cubit/expense/expense_cubit.dart';

class AppProviders {
  static List<BlocProvider> build() {
    final authDataSource = AuthRemoteDataSourceImpl();
    final authRepository = AuthRepositoryImpl(authDataSource);
    final transactionRepository = TransactionRepositoryImpl(
      TransactionService(),
    );
    final accountRepository = AccountRepositoryImpl(AccountService());

    return [
      BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(
          loginUseCase: LoginUseCase(authRepository),
          registerUseCase: RegisterUseCase(authRepository),
          resetPasswordUseCase: ResetPasswordUseCase(authRepository),
          logoutUseCase: LogoutUseCase(authRepository),
          changePasswordUseCase: ChangePasswordUseCase(authRepository),
          signInWithGoogleUseCase: SignInWithGoogleUseCase(authRepository),
        ),
      ),
      BlocProvider<ExpenseCubit>(
        create: (context) => ExpenseCubit(
          watchTransactionsUseCase: WatchTransactionsUseCase(
            transactionRepository,
          ),
          addTransactionUseCase: AddTransactionUseCase(transactionRepository),
          updateTransactionUseCase: UpdateTransactionUseCase(
            transactionRepository,
          ),
          deleteTransactionUseCase: DeleteTransactionUseCase(
            transactionRepository,
          ),
          updateVibeStatusUseCase: UpdateVibeStatusUseCase(
            transactionRepository,
          ),
          resetVibeStatusesUseCase: ResetVibeStatusesUseCase(
            transactionRepository,
          ),
        ),
      ),
      BlocProvider<AccountCubit>(
        create: (context) => AccountCubit(
          watchUserProfileUseCase: WatchUserProfileUseCase(accountRepository),
          clearTransactionHistoryUseCase: ClearTransactionHistoryUseCase(
            accountRepository,
          ),
          updateProfileUseCase: UpdateProfileUseCase(accountRepository),
          updateVibeScheduleUseCase: UpdateVibeScheduleUseCase(
            accountRepository,
          ),
          deleteCurrentUserAccountUseCase: DeleteCurrentUserAccountUseCase(
            accountRepository,
          ),
        ),
      ),
    ];
  }
}
