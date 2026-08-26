import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/message.dart';
import '../../models/user_profile.dart';
import '../../providers/message_provider.dart';
import '../../services/auth_service.dart';

class ComposeMessageScreen extends StatefulWidget {
  const ComposeMessageScreen({super.key});

  @override
  State<ComposeMessageScreen> createState() => _ComposeMessageScreenState();
}

class _ComposeMessageScreenState extends State<ComposeMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final AuthService _authService = AuthService();
  MessageType _messageType = MessageType.normal;
  MessagePriority _priority = MessagePriority.medium;
  List<UserProfile> _recipients = const [];
  UserProfile? _selectedRecipient;
  bool _isLoadingRecipients = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadRecipients();
  }

  Future<void> _loadRecipients() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      final users = await _authService.getUsers();
      final availableUsers = users
          .where((user) => user.uid != currentUserId && user.name != null && user.name!.trim().isNotEmpty)
          .toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _recipients = availableUsers;
        _selectedRecipient = availableUsers.isNotEmpty ? availableUsers.first : null;
        _isLoadingRecipients = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() => _isLoadingRecipients = false);
    }
  }

  Future<void> _submit() async {
    final messageText = _controller.text.trim();
    if (!Message.validateMessage(messageText)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message before sending.')),
      );
      return;
    }

    if (_selectedRecipient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a recipient before sending.')),
      );
      return;
    }

    final provider = context.read<MessageProvider>();
    if (provider.isSending) {
      return;
    }

    setState(() => _isSending = true);

    try {
      if (_messageType == MessageType.emergency) {
        if (_priority == MessagePriority.critical) {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Critical Emergency'),
              content: const Text('This message will be marked as a critical emergency. Continue?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.sosRed),
                  child: const Text('Send'),
                ),
              ],
            ),
          );

          if (confirmed != true) {
            setState(() => _isSending = false);
            return;
          }
        }

        await provider.sendEmergencyMessage(
          message: messageText,
          priority: _priority,
          recipientId: _selectedRecipient!.uid,
        );
      } else {
        await provider.sendMessage(
          message: messageText,
          recipientId: _selectedRecipient!.uid,
        );
      }

      if (!context.mounted) {
        return;
      }

      _controller.clear();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _messageType == MessageType.emergency ? 'Emergency message sent.' : 'Message sent.',
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Unable to send this message right now.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MessageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_messageType == MessageType.emergency ? 'Emergency Message' : 'Compose Message'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SegmentedButton<MessageType>(
                segments: const [
                  ButtonSegment(value: MessageType.normal, label: Text('Normal')),
                  ButtonSegment(value: MessageType.emergency, label: Text('Emergency')),
                ],
                selected: {_messageType},
                onSelectionChanged: (selection) {
                  setState(() => _messageType = selection.first);
                },
              ),
              const SizedBox(height: 16),
              if (_messageType == MessageType.emergency) ...[
                DropdownButtonFormField<MessagePriority>(
                  initialValue: _priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: MessagePriority.values.map((priority) {
                    final label = switch (priority) {
                      MessagePriority.medium => 'Medium',
                      MessagePriority.high => 'High',
                      MessagePriority.critical => 'Critical',
                      MessagePriority.low => 'Low',
                    };
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _priority = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (_isLoadingRecipients)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_recipients.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('No TraceNet users are available yet.'),
                )
              else
                DropdownButtonFormField<String>(
                  initialValue: _selectedRecipient?.uid,
                  decoration: const InputDecoration(labelText: 'Recipient'),
                  items: _recipients.map((user) {
                    final label = user.name?.trim().isNotEmpty == true ? user.name! : user.email ?? 'TraceNet user';
                    return DropdownMenuItem(
                      value: user.uid,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    final match = _recipients.where((user) => user.uid == value).firstOrNull;
                    if (match != null) {
                      setState(() => _selectedRecipient = match);
                    }
                  },
                ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: _messageType == MessageType.emergency ? 'Emergency message' : 'Message',
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: provider.isSending ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: provider.isSending || _isSending ? null : _submit,
                      child: provider.isSending || _isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_messageType == MessageType.emergency ? 'Send Emergency' : 'Send'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on Iterable<dynamic> {
  dynamic get firstOrNull => isEmpty ? null : first;
}
