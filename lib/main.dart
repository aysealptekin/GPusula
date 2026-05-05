import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/pages/add_expense_page.dart';
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

void main() {
  final datasource = AuthRemoteDataSourceImpl();
  final repository = AuthRepositoryImpl(datasource);
  final loginUseCase = LoginUseCase(repository);
  final authCubit = AuthCubit(loginUseCase);

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
        AppRoutes.login: (context) =>
            LoginPage(authCubit: context.read<AuthCubit>()),
        AppRoutes.register: (context) => const RegistrationPage(),
        AppRoutes.resetPassword: (context) => const ResetPasswordPage(),
        AppRoutes.homepage: (context) => const HomePage(),
        AppRoutes.vibeCheck: (context) => const VibeCheckPage(),
        AppRoutes.addExpense: (context) => const AddExpensePage(),
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
