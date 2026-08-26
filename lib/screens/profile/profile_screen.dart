import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';

/// Profile Screen
/// User profile information and management
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
      ),
      body: const Center(
        child: Text('Profile Screen - Coming Soon'),
      ),
    );
  }
}
