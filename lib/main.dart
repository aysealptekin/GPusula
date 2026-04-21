import 'package:flutter/material.dart';
import 'package:roadmap/screens/categories_screen.dart';
import 'package:roadmap/screens/home_page.dart';
import 'package:roadmap/screens/vibe_check_screen.dart';
import 'package:roadmap/theme/app_theme.dart';
import 'screens/add_expense_screen.dart';
import 'screens/login_screen.dart';
import 'screens/reset_password.dart';
import 'screens/registration_screen.dart';
import 'screens/transactions_screen.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const RoadMapApp());
}

class RoadMapApp extends StatelessWidget {
  const RoadMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPUSULA',
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegistrationScreen(),
        AppRoutes.resetPassword: (context) => const ResetPasswordScreen(),
        AppRoutes.homepage: (context) => const HomePageScreen(),
        AppRoutes.vibeCheck: (context) => const VibeCheckScreen(),
        AppRoutes.addExpense: (context) => const AddExpenseScreen(),
        AppRoutes.transactions: (context) => const TransactionsScreen(),
        AppRoutes.categories: (context) => const CategoriesScreen(),
      },
    );
  }
}
