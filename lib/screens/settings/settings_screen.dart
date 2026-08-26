import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';

/// Settings Screen
/// User settings and preferences configuration
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
      ),
      body: const Center(
        child: Text('Settings Screen - Coming Soon'),
      ),
    );
  }
}
