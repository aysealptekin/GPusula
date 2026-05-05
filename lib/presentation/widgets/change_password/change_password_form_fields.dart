import 'package:flutter/material.dart';
import '../../../core/utils/app_validators.dart';
import '../custom_text_field.dart';

class ChangePasswordFormFields extends StatelessWidget {
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmNewPasswordController;
  final String? Function(String?) oldPasswordValidator;
  final String? Function(String?) confirmNewPasswordValidator;

  const ChangePasswordFormFields({
    super.key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmNewPasswordController,
    required this.oldPasswordValidator,
    required this.confirmNewPasswordValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: oldPasswordController,
          labelText: "Eski Şifre",
          hintText: "",
          icon: Icons.lock_outline,
          isPassword: true,
          isRequired: true,
          validator: oldPasswordValidator,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: newPasswordController,
          labelText: "Yeni Şifre",
          hintText: "",
          icon: Icons.password,
          isPassword: true,
          isRequired: true,
          validator: AppValidators.sifreDogrula,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: confirmNewPasswordController,
          labelText: "Yeni Şifre Tekrar",
          hintText: "",
          icon: Icons.password,
          isPassword: true,
          isRequired: true,
          validator: confirmNewPasswordValidator,
        ),
      ],
    );
  }
}
