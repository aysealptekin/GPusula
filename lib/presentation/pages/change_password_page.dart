import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_validators.dart';
import 'package:roadmap/presentation/widgets/custom_text_field.dart';

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
                const Icon(
                  Icons.lock_reset,
                  size: 55,
                  color: AppColors.inputIcon,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Şifre Değiştir",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    color: AppColors.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Güvenliğin için yeni bir şifre belirle",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _oldPasswordController,
                  labelText: "Eski Şifre",
                  hintText: "",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isRequired: true,
                  validator: _oldPasswordValidator,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _newPasswordController,
                  labelText: "Yeni Şifre",
                  hintText: "",
                  icon: Icons.password,
                  isPassword: true,
                  isRequired: true,
                  validator: AppValidators.sifreDogrula,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _confirmNewPasswordController,
                  labelText: "Yeni Şifre Tekrar",
                  hintText: "",
                  icon: Icons.password,
                  isPassword: true,
                  isRequired: true,
                  validator: _confirmNewPasswordValidator,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primarySoft,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "ŞİFREYİ DEĞİŞTİR",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
