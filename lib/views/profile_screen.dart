import 'package:flutter/material.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile', style: AppStyles.heading1)),
      body: const Center(child: Text('User profile placeholder')),
    );
  }
}
