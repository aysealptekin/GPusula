import 'package:flutter/material.dart';
import 'package:roadmap/core/utils/app_validators.dart';
import 'package:roadmap/presentation/widgets/common/custom_text_field.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: emailController,
          hintText: "E-posta",
          icon: Icons.email_outlined,
          validator: AppValidators.emailDogrula,
        ),

        const SizedBox(height: 20),

        CustomTextField(
          controller: passwordController,
          hintText: "Şifre",
          icon: Icons.lock_outline,
          isPassword: true,
          validator: AppValidators.sifreDogrula,
        ),
      ],
    );
  }
}
