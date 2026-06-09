import 'dart:convert';

import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String email;
  final String? photoUrl;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.email,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF1F2430), Color(0xFF2B3242)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 34, backgroundImage: _profileImage()),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _profileImage() {
    final url = photoUrl;
    if (url != null && url.trim().isNotEmpty) {
      if (url.startsWith('data:image')) {
        return MemoryImage(base64Decode(url.split(',').last));
      }

      return NetworkImage(url);
    }

    return const AssetImage('assets/merto1.png');
  }
}
