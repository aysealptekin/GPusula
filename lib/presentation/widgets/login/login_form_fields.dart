import 'package:flutter/material.dart';
import 'package:roadmap/core/utils/app_validators.dart';
import 'package:roadmap/presentation/widgets/custom_text_field.dart';

class LoginFormFields extends StatelessWidget
{
    final TextEditingController _emailController;
    final TextEditingController _passwordController;


    const LoginFormFields
    (
        {
            super.key,
            required this._emailController,
            required this._passwordController,
        }
    );


    @override
    Widget build (BuildContext context)
    {
        return Column
        (
            childeren:
            [
                CustomTextField
                (
                    controller: _emailController,
                    hintText: "E-posta",
                    icon: Icons.email_outlined,
                    validator:AppValidators.emailDogrula,
                ),

                const SizedBox(height: 20),

                CustomTextField
                (
                    controller: _passwordController,
                    hintText: "Sifre",
                    icon: Icons.lock_outline,
                    isPassword: true,
                ),
            ],
        );
    }

}