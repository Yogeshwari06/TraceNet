import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/message.dart';
import '../../providers/message_provider.dart';

class MessageDetailsScreen extends StatefulWidget {
  const MessageDetailsScreen({super.key, required this.message});

  final Message message;

  @override
  State<MessageDetailsScreen> createState() => _MessageDetailsScreenState();
}

class _MessageDetailsScreenState extends State<MessageDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageProvider>().markAsRead(widget.message.messageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.message;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoTile('Sender', message.senderName),
            _infoTile('Phone', message.senderPhone.isNotEmpty ? message.senderPhone : 'Not available'),
            _infoTile('Type', message.type.name),
            _infoTile('Priority', message.priority.name),
            _infoTile('Status', message.deliveryStatus.name),
            _infoTile('Sent', DateFormat('MMM d, yyyy • h:mm a').format(message.timestamp.toLocal())),
            const SizedBox(height: 16),
            const Text('Message', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(message.message),
            ),
            if (message.latitude != null || message.longitude != null) ...[
              const SizedBox(height: 16),
              const Text('Location', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Lat: ${message.latitude?.toStringAsFixed(5) ?? 'N/A'} • Long: ${message.longitude?.toStringAsFixed(5) ?? 'N/A'}',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
