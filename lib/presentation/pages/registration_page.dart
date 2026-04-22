import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/custom_text_field.dart';
import '../../core/utils/app_validators.dart';

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

  String? _sifretekrari(String? yenisifre) {
    if (yenisifre != _passwordController.text) {
      return "sifreler ayni olmalidir";
    }
    return null;
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
                const Icon(
                  Icons.person_add,
                  size: 50,
                  color: AppColors.inputIcon,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Yeni Hesap Oluştur',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: AppColors.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _nameController,
                  labelText: " İsim Soyisim",
                  isRequired: true,
                  hintText: "",
                  icon: Icons.person,
                  validator: AppValidators.isimZorunlu,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _emailController,
                  labelText: " Mail",
                  isRequired: true,
                  hintText: '___@___.com',
                  icon: Icons.mail,
                  validator: AppValidators.emailDogrula,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Şifre',
                  hintText: '',
                  icon: Icons.password,
                  isRequired: true,
                  isPassword: true,
                  validator: AppValidators.sifreDogrula,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: "Şifre tekrarı",
                  hintText: '',
                  icon: Icons.password,
                  isPassword: true,
                  validator: _sifretekrari,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("kayit oldu");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Kayit basarili, giris sayfasina yonlendiriliyorsunuz",
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );

                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.pop(context);
                      });
                    } else {
                      print("hatalari duzeltin");
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
                  child: const Text(
                    "KAYIT OL",
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
