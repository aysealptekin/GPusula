import 'package:flutter/material.dart';

class ProfileAccountDialogs {
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String message,
    required String actionText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D24),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              actionText,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  static Future<String?> askPasswordForDelete(BuildContext context) {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D24),
        title: const Text(
          'Hesap silinsin mi?',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Hesabın ve tüm işlem kayıtların kalıcı olarak silinecek.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Şifren',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text(
              'Hesabı Sil',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }
}
