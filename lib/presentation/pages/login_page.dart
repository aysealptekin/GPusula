import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roadmap/core/constants/app_colors.dart';
import 'package:roadmap/core/routes/app_routes.dart';
import 'package:roadmap/presentation/bloc/auth_cubit.dart';
import 'package:roadmap/presentation/bloc/auth_state.dart';
import 'package:roadmap/presentation/widgets/login/login_actions.dart';
import 'package:roadmap/presentation/widgets/login/login_footer.dart';
import 'package:roadmap/presentation/widgets/login/login_form_fields.dart';
import 'package:roadmap/presentation/widgets/login/login_header.dart';

class LoginPage extends StatefulWidget {
  final AuthCubit authCubit;

  const LoginPage({
    super.key,
    required this.authCubit,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleAuthSuccess() {
    Navigator.pushReplacementNamed(context, AppRoutes.homepage);
  }

  void _handleAuthError(AuthError errorState) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorState.message)),
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
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
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const LoginHeader(),
                        LoginFormFields(
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                        const SizedBox(height: 10),
                        LoginActions(
                          isLoading: isLoading,
                          onForgotPassword: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.resetPassword,
                            );
                          },
                          onLogin: _onLoginPressed,
                          onGoogleSignIn: () {
                            context.read<AuthCubit>().signInWithGoogle();
                          },
                        ),
                        const SizedBox(height: 30),
                        LoginFooter(
                          isLoading: isLoading,
                          onRegister: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.register,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
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