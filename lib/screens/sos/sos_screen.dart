import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../providers/message_provider.dart';
import '../../services/location_service.dart';

/// SOS Screen
/// Emergency SOS alert dispatch screen
class SosScreen extends StatefulWidget {
  const SosScreen({Key? key}) : super(key: key);

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final LocationService _locationService = LocationService();
  bool _isSending = false;

  Future<void> _sendSos() async {
    if (_isSending) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Emergency SOS'),
        content: const Text('Send an emergency alert to the TraceNet community?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.sosRed),
            child: const Text('Send SOS'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _isSending = true);

    try {
      final position = await _locationService.getCurrentPosition();
      await context.read<MessageProvider>().sendSOSMessage(
        message: 'Emergency SOS alert',
        latitude: position?.latitude,
        longitude: position?.longitude,
      );

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SOS alert sent successfully.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to send the SOS alert. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.sosTitle),
      ),
      body: Center(
        child: _isSending
            ? const CircularProgressIndicator()
            : const Text('Use the button below to send an emergency alert.'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSending ? null : _sendSos,
        label: const Text(AppStrings.sendSOS),
        icon: const Icon(Icons.emergency),
        backgroundColor: AppColors.sosRed,
      ),
    );
  }
}
