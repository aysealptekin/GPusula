import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/app_routes.dart';
import 'data/account/repositories/account_repository_impl.dart';
import 'data/auth/datasources/auth_remote_datasource.dart';
import 'data/auth/repositories/auth_repository_impl.dart';
import 'data/services/account_service.dart';
import 'data/services/transaction_service.dart';
import 'data/transaction/repositories/transaction_repository_impl.dart';
import 'domain/account/usecases/clear_transaction_history_usecase.dart';
import 'domain/account/usecases/delete_current_user_account_usecase.dart';
import 'domain/account/usecases/update_profile_usecase.dart';
import 'domain/account/usecases/watch_user_profile_usecase.dart';
import 'domain/auth/usecases/change_password_usecase.dart';
import 'domain/auth/usecases/login_usecase.dart';
import 'domain/auth/usecases/logout_usecase.dart';
import 'domain/auth/usecases/register_usecase.dart';
import 'domain/auth/usecases/reset_password_usecase.dart';
import 'domain/auth/usecases/sign_in_with_google_usecase.dart';
import 'domain/transaction/usecases/add_transaction_usecase.dart';
import 'domain/transaction/usecases/delete_transaction_usecase.dart';
import 'domain/transaction/usecases/update_transaction_usecase.dart';
import 'domain/transaction/usecases/update_vibe_status_usecase.dart';
import 'domain/transaction/usecases/watch_transactions_usecase.dart';
import 'presentation/bloc/auth_cubit.dart';
import 'presentation/cubit/account/account_cubit.dart';
import 'presentation/cubit/expense/expense_cubit.dart';
import 'presentation/pages/adventure_page.dart';
import 'presentation/pages/categories_page.dart';
import 'presentation/pages/change_password_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/pusula_ai_page.dart';
import 'presentation/pages/registration_page.dart';
import 'presentation/pages/reset_password_page.dart';
import 'presentation/pages/transactions_page.dart';
import 'presentation/pages/vibe_check_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final datasource = AuthRemoteDataSourceImpl();
  final repository = AuthRepositoryImpl(datasource);
  final transactionService = TransactionService();
  final transactionRepository = TransactionRepositoryImpl(transactionService);
  final accountService = AccountService();
  final accountRepository = AccountRepositoryImpl(accountService);

  final authCubit = AuthCubit(
    loginUseCase: LoginUseCase(repository),
    registerUseCase: RegisterUseCase(repository),
    resetPasswordUseCase: ResetPasswordUseCase(repository),
    logoutUseCase: LogoutUseCase(repository),
    changePasswordUseCase: ChangePasswordUseCase(repository),
    signInWithGoogleUseCase: SignInWithGoogleUseCase(repository),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => authCubit),
        BlocProvider(
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
          ),
        ),
        BlocProvider(
          create: (context) => AccountCubit(
            watchUserProfileUseCase: WatchUserProfileUseCase(accountRepository),
            clearTransactionHistoryUseCase: ClearTransactionHistoryUseCase(
              accountRepository,
            ),
            updateProfileUseCase: UpdateProfileUseCase(accountRepository),
            deleteCurrentUserAccountUseCase: DeleteCurrentUserAccountUseCase(
              accountRepository,
            ),
          ),
        ),
      ],
      child: const RoadMapApp(),
    ),
  );
}

class RoadMapApp extends StatelessWidget {
  const RoadMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPUSULA',
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegistrationPage(),
        AppRoutes.resetPassword: (context) => const ResetPasswordPage(),
        AppRoutes.homepage: (context) => const HomePage(),
        AppRoutes.vibeCheck: (context) => const VibeCheckPage(),
        AppRoutes.transactions: (context) => const TransactionsPage(),
        AppRoutes.categories: (context) => const CategoriesPage(),
        AppRoutes.adventure: (context) => const AdventurePage(),
        AppRoutes.pusulaAi: (context) => const PusulaAiPage(),
        AppRoutes.profile: (context) => const ProfilePage(),
        AppRoutes.changePassword: (context) => const ChangePasswordPage(),
      },
    );
  }
}
