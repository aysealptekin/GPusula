import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/pages/adventure_page.dart';
import 'presentation/pages/change_password_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/pusula_ai_page.dart';
import 'presentation/pages/transactions_page.dart';
import 'presentation/pages/vibe_check_page.dart';
import 'presentation/pages/categories_page.dart';
import 'presentation/pages/home_page.dart';
import 'data/auth/datasources/auth_remote_datasource.dart';
import 'data/auth/repositories/auth_repository_impl.dart';
import 'domain/auth/usecases/login_usecase.dart';
import 'presentation/bloc/auth_cubit.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/reset_password_page.dart';
import 'presentation/pages/registration_page.dart';
import 'core/routes/app_routes.dart';
import 'domain/auth/usecases/register_usecase.dart';
import 'domain/auth/usecases/reset_password_usecase.dart';
import 'domain/auth/usecases/logout_usecase.dart';

void main() {
  final datasource = AuthRemoteDataSourceImpl();
  final repository = AuthRepositoryImpl(datasource);

  final authCubit = AuthCubit(
    loginUseCase: LoginUseCase(repository),
    registerUseCase: RegisterUseCase(repository),
    resetPasswordUseCase: ResetPasswordUseCase(repository),
    logoutUseCase: LogoutUseCase(repository),
  );

  runApp(
    BlocProvider(create: (context) => authCubit, child: const RoadMapApp()),
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
