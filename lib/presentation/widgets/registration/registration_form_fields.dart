import 'package:flutter/material.dart';
import 'package:roadmap/core/utils/app_validators.dart';
import 'package:roadmap/presentation/widgets/common/custom_text_field.dart';

class RegistrationFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? Function(String?) confirmPasswordValidator;

  const RegistrationFormFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.confirmPasswordValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          labelText: " İsim Soyisim",
          isRequired: true,
          hintText: "",
          icon: Icons.person,
          validator: AppValidators.isimZorunlu,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: emailController,
          labelText: " Mail",
          isRequired: true,
          hintText: '___@gmail.com',
          icon: Icons.mail,
          validator: AppValidators.emailDogrula,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: passwordController,
          labelText: 'Şifre',
          hintText: '',
          icon: Icons.password,
          isRequired: true,
          isPassword: true,
          validator: AppValidators.sifreDogrula,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: confirmPasswordController,
          labelText: "Şifre tekrarı",
          hintText: '',
          icon: Icons.password,
          isPassword: true,
          validator: confirmPasswordValidator,
        ),
      ],
    );
  }
}
