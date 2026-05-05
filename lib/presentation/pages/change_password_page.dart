import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/change_password/change_password_header.dart';
import '../widgets/change_password/change_password_form_fields.dart';
import '../widgets/change_password/change_password_actions.dart';

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
      return "Eski şifre boş olamaz";
    }
    return null;
  }

  String? _confirmNewPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Yeni şifre tekrarı boş olamaz";
    }
    if (value != _newPasswordController.text) {
      return "Yeni şifreler aynı olmalı";
    }
    return null;
  }

  void _changePassword() {
    //asil is burda
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Şifre başarıyla değiştirildi"),
          backgroundColor: AppColors.success,
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
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
                  confirmNewPasswordController: _confirmNewPasswordController,
                  oldPasswordValidator: _oldPasswordValidator,
                  confirmNewPasswordValidator: _confirmNewPasswordValidator,
                ),

                const SizedBox(height: 24),
                ChangePasswordActions(onExecute: _changePassword),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
