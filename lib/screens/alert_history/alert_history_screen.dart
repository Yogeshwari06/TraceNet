import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';

/// Alert History Screen
/// Historical alerts and SOS events
class AlertHistoryScreen extends StatefulWidget {
  const AlertHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AlertHistoryScreen> createState() => _AlertHistoryScreenState();
}

class _AlertHistoryScreenState extends State<AlertHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.alertHistoryTitle),
      ),
      body: const Center(
        child: Text('Alert History Screen - Coming Soon'),
      ),
    );
  }
}
