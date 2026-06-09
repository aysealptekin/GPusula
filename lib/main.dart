import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/app_providers.dart';
import 'core/routes/app_routes.dart';
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

  runApp(
    MultiBlocProvider(
      providers: AppProviders.build(),
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
