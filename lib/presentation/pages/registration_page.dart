import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../widgets/registration/registration_actions.dart';
import '../widgets/registration/registration_form_fields.dart';
import '../widgets/registration/registration_header.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isProcessLoading = false;

  String? _sifretekrari(String? yenisifre) {
    if (yenisifre != _passwordController.text) {
      return "sifreler ayni olmalidir";
    }
    return null;
  }

  Future<void> _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessLoading = true;
    });

    final navigator = Navigator.of(context);
    await Future.delayed(const Duration(seconds: 3));
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Kayit basarili, giris sayfasina yonlendiriliyorsunuz"),
        backgroundColor: AppColors.success,
      ),
    );

    setState(() {
      _isProcessLoading = false;
    });

    navigator.pop();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
          padding: const EdgeInsets.all(50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const RegistrationHeader(),
                RegistrationFormFields(
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  confirmPasswordValidator: _sifretekrari,
                ),
                const SizedBox(height: 10),

                RegistrationActions(
                  onRegister: _onRegisterPressed,
                  isLoading: _isProcessLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
