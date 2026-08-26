import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../models/message.dart';
import '../services/message_service.dart';

class MessageProvider extends ChangeNotifier {
  MessageProvider({MessageService? messageService})
      : _messageService = messageService ?? MessageService();

  final MessageService _messageService;
  List<Message> _messages = const [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _errorMessage;
  StreamSubscription<List<Message>>? _messagesSubscription;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;
  int get unreadCount {
    final uid = _messageService.currentUserId;
    if (uid == null) {
      return 0;
    }

    return _messages.where((message) {
      if (message.isRead) {
        return false;
      }
      if (message.recipientId == null) {
        return true;
      }
      return message.recipientId == uid || message.senderId == uid;
    }).length;
  }

  Future<void> loadMessages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _messages = await _messageService.getMessages();
      _errorMessage = null;
    } catch (_) {
      _errorMessage = 'Unable to load messages right now.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startListening() {
    if (_messagesSubscription != null) {
      return;
    }

    _messagesSubscription = _messageService.watchMessages().listen(
      (messages) {
        _messages = messages;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (_) {
        _errorMessage = 'Realtime updates are unavailable right now.';
        notifyListeners();
      },
    );
  }

  Future<void> sendMessage({
    required String message,
    MessageType type = MessageType.normal,
    MessagePriority priority = MessagePriority.medium,
    String? recipientId,
    double? latitude,
    double? longitude,
  }) async {
    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final sentMessage = await _messageService.sendMessage(
        message: message,
        type: type,
        priority: priority,
        recipientId: recipientId,
        latitude: latitude,
        longitude: longitude,
      );

      final updatedList = [sentMessage, ..._messages];
      _messages = updatedList;
      notifyListeners();
      return;
    } catch (error) {
      _errorMessage = _friendlyError(error);
      notifyListeners();
      rethrow;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> sendEmergencyMessage({
    required String message,
    required MessagePriority priority,
    String? recipientId,
    double? latitude,
    double? longitude,
  }) async {
    return sendMessage(
      message: message,
      type: MessageType.emergency,
      priority: priority,
      recipientId: recipientId,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<void> sendSOSMessage({
    required String message,
    double? latitude,
    double? longitude,
  }) async {
    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final sentMessage = await _messageService.sendSOSMessage(
        message: message,
        latitude: latitude,
        longitude: longitude,
      );

      _messages = [sentMessage, ..._messages];
      notifyListeners();
      return;
    } catch (error) {
      _errorMessage = _friendlyError(error);
      notifyListeners();
      rethrow;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      await _messageService.markMessageAsRead(messageId);
      final updatedList = _messages.map((message) {
        if (message.messageId == messageId) {
          return message.copyWith(isRead: true);
        }
        return message;
      }).toList();
      _messages = updatedList;
      notifyListeners();
    } catch (_) {
      _errorMessage = 'Unable to update the message status.';
      notifyListeners();
    }
  }

  Future<void> refreshMessages() async {
    await loadMessages();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _friendlyError(Object error) {
    if (error is FormatException) {
      return error.message;
    }
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You do not have permission to send this message.';
        case 'unauthenticated':
          return 'Please sign in again to continue.';
        case 'unavailable':
        case 'network-request-failed':
          return 'Network connection is unavailable. Please try again.';
        case 'not-found':
          return 'The requested message could not be found.';
        case 'cancelled':
          return 'The request was cancelled.';
        case 'already-exists':
          return 'This message already exists.';
        default:
          return 'Something went wrong while sending the message.';
      }
    }
    return 'Something went wrong while processing your message.';
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
