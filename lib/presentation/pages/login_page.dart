import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roadmap/core/constants/app_colors.dart';
import 'package:roadmap/core/routes/app_routes.dart';
import 'package:roadmap/core/utils/app_validators.dart';
import 'package:roadmap/presentation/bloc/auth_cubit.dart';
import 'package:roadmap/presentation/bloc/auth_state.dart';
import 'package:roadmap/presentation/widgets/custom_text_field.dart';

// LoginPage -> AuthCubit
// AuthCubit -> LoginUseCase
// LoginUseCase -> AuthRepository (abstraction)
// AuthRepositoryImpl -> AuthRemoteDataSource

class LoginPage extends StatefulWidget {
  final AuthCubit authCubit;

  const LoginPage({super.key, required this.authCubit});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _handleAuthSuccess() {
    Navigator.pushReplacementNamed(context, AppRoutes.homepage);
  }

  void _handleAuthError(AuthError errorState) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(errorState.message)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.authCubit,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            _handleAuthSuccess();
          } else if (state is AuthError) {
            _handleAuthError(state);
          }
        },
        builder: (context, state) {
          final bool isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: AppColors.bgDark,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 100),
                      const Icon(
                        Icons.navigation,
                        size: 100,
                        color: AppColors.textMain,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "G-PUSULA",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMain,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Başla!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 50),
                      CustomTextField(
                        controller: _emailController,
                        hintText: "E-posta",
                        icon: Icons.email_outlined,
                        validator: AppValidators.emailDogrula,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: "Şifre",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.resetPassword,
                                  );
                                },
                          child: const Text(
                            "Şifremi Unuttum",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().login(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primarySoft,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isLoading ? "Yükleniyor..." : "GİRİŞ YAP",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<AuthCubit>().signInWithGoogle();
                              },
                        icon: const Icon(Icons.g_mobiledata, size: 30),
                        label: Text(
                          isLoading ? "Yükleniyor" : "Google ile Devam Et",
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textMain,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Hesabın yok mu?",
                            style: TextStyle(color: AppColors.textMain),
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.register,
                                    );
                                  },
                            child: const Text(
                              "Kayıt Ol",
                              style: TextStyle(
                                color: AppColors.primarySoft,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
