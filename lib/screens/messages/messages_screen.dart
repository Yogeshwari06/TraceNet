import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/message.dart';
import '../../providers/message_provider.dart';
import '../../routes/app_routes.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MessageProvider>();
      provider.startListening();
      provider.loadMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MessageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.chatTitle),
        actions: [
          if (provider.unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.sosRed,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${provider.unreadCount}',
                    style: const TextStyle(
                      color: AppColors.secondaryWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.composeMessage),
        child: const Icon(Icons.edit),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.refreshMessages(),
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(MessageProvider provider) {
    if (provider.isLoading && provider.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.statusError),
              const SizedBox(height: 16),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: provider.refreshMessages,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.messages.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No messages yet. Start the conversation.'),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.messages.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final message = provider.messages[index];
        final isEmergency = message.type == MessageType.emergency || message.type == MessageType.sos;
        final isUnread = !message.isRead;

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: isEmergency ? AppColors.sosRed.withValues(alpha: 0.04) : null,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: isEmergency ? AppColors.sosRed : AppColors.primaryDarkBlueLight,
              child: Icon(
                isEmergency ? Icons.warning_amber_rounded : Icons.message_rounded,
                color: isEmergency ? AppColors.secondaryWhite : AppColors.primaryDarkBlue,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    message.senderName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (isUnread)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.statusError,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  message.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _priorityBadge(message.priority),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimestamp(message.timestamp),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              if (isUnread) {
                await provider.markAsRead(message.messageId);
              }
              if (!context.mounted) {
                return;
              }
              Navigator.of(context).pushNamed(
                AppRoutes.messageDetails,
                arguments: message,
              );
            },
          ),
        );
      },
    );
  }

  Widget _priorityBadge(MessagePriority priority) {
    final color = switch (priority) {
      MessagePriority.low => AppColors.statusSuccess,
      MessagePriority.medium => AppColors.statusWarning,
      MessagePriority.high => AppColors.statusError,
      MessagePriority.critical => AppColors.sosRed,
    };

    final label = switch (priority) {
      MessagePriority.low => 'Low',
      MessagePriority.medium => 'Medium',
      MessagePriority.high => 'High',
      MessagePriority.critical => 'Critical',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM d, h:mm a').format(timestamp.toLocal());
  }
}
