import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../widgets/change_password/change_password_actions.dart';
import '../widgets/change_password/change_password_form_fields.dart';
import '../widgets/change_password/change_password_header.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _oldPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Eski sifre bos olamaz";
    }
    return null;
  }

  String? _confirmNewPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Yeni sifre tekrari bos olamaz";
    }
    if (value != _newPasswordController.text) {
      return "Yeni sifreler ayni olmali";
    }
    return null;
  }

  void _changePassword() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().changePassword(
      oldPassword: _oldPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PasswordChanged) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sifre basariyla degistirildi"),
              backgroundColor: AppColors.success,
            ),
          );

          Navigator.pop(context);
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.bgDark,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
              onPressed: isLoading ? null : () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ChangePasswordHeader(),
                    const SizedBox(height: 30),
                    ChangePasswordFormFields(
                      oldPasswordController: _oldPasswordController,
                      newPasswordController: _newPasswordController,
                      confirmNewPasswordController:
                          _confirmNewPasswordController,
                      oldPasswordValidator: _oldPasswordValidator,
                      confirmNewPasswordValidator: _confirmNewPasswordValidator,
                    ),
                    const SizedBox(height: 24),
                    ChangePasswordActions(
                      onExecute: isLoading ? () {} : _changePassword,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
