import 'package:flutter/material.dart';
import 'package:roadmap/screens/categories_screen.dart';
import 'package:roadmap/screens/change_password.dart';
import 'package:roadmap/screens/home_page.dart';
import 'package:roadmap/screens/profile_screen.dart';
import 'package:roadmap/screens/pusula_ai.dart';
import 'package:roadmap/screens/seruven_screen.dart';
import 'package:roadmap/screens/vibe_check_screen.dart';
import 'screens/add_expense_screen.dart';
import 'presentation/pages/login_page.dart';
import 'screens/reset_password.dart';
import 'presentation/pages/registration_page.dart';
import 'screens/transactions_screen.dart';
import 'core/routes/app_routes.dart';

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
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegistrationPage(),
        AppRoutes.resetPassword: (context) => const ResetPasswordScreen(),
        AppRoutes.homepage: (context) => const HomePageScreen(),
        AppRoutes.vibeCheck: (context) => const VibeCheckScreen(),
        AppRoutes.addExpense: (context) => const AddExpenseScreen(),
        AppRoutes.transactions: (context) => const TransactionsScreen(),
        AppRoutes.categories: (context) => const CategoriesScreen(),
        AppRoutes.seruven: (context) => const SeruvenScreen(),
        AppRoutes.pusulaAi: (context) => const PusulaAiScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.changePassword: (context) => const ChangePasswordScreen(),
      },
    );
  }
}
