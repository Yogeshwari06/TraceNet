import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { normal, emergency, sos }
enum MessagePriority { low, medium, high, critical }
enum MessageDeliveryStatus { sending, sent, delivered, failed }

extension MessageTypeExtension on MessageType {
  String get value => switch (this) {
        MessageType.normal => 'normal',
        MessageType.emergency => 'emergency',
        MessageType.sos => 'sos',
      };

  static MessageType fromValue(String? value) {
    switch (value) {
      case 'emergency':
        return MessageType.emergency;
      case 'sos':
        return MessageType.sos;
      case 'normal':
      default:
        return MessageType.normal;
    }
  }
}

extension MessagePriorityExtension on MessagePriority {
  String get value => switch (this) {
        MessagePriority.low => 'low',
        MessagePriority.medium => 'medium',
        MessagePriority.high => 'high',
        MessagePriority.critical => 'critical',
      };

  static MessagePriority fromValue(String? value) {
    switch (value) {
      case 'low':
        return MessagePriority.low;
      case 'high':
        return MessagePriority.high;
      case 'critical':
        return MessagePriority.critical;
      case 'medium':
      default:
        return MessagePriority.medium;
    }
  }
}

extension MessageDeliveryStatusExtension on MessageDeliveryStatus {
  String get value => switch (this) {
        MessageDeliveryStatus.sending => 'sending',
        MessageDeliveryStatus.sent => 'sent',
        MessageDeliveryStatus.delivered => 'delivered',
        MessageDeliveryStatus.failed => 'failed',
      };

  static MessageDeliveryStatus fromValue(String? value) {
    switch (value) {
      case 'sending':
        return MessageDeliveryStatus.sending;
      case 'delivered':
        return MessageDeliveryStatus.delivered;
      case 'failed':
        return MessageDeliveryStatus.failed;
      case 'sent':
      default:
        return MessageDeliveryStatus.sent;
    }
  }
}

class Message {
  final String messageId;
  final String senderId;
  final String senderName;
  final String senderPhone;
  final String message;
  final MessageType type;
  final MessagePriority priority;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final String? recipientId;
  final bool isRead;
  final MessageDeliveryStatus deliveryStatus;

  const Message({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.senderPhone,
    required this.message,
    required this.type,
    required this.priority,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.recipientId,
    required this.isRead,
    required this.deliveryStatus,
  });

  factory Message.fromMap(Map<String, dynamic>? map, {required String messageId}) {
    if (map == null) {
      return Message(
        messageId: messageId,
        senderId: '',
        senderName: 'Unknown',
        senderPhone: '',
        message: '',
        type: MessageType.normal,
        priority: MessagePriority.medium,
        timestamp: DateTime.now().toUtc(),
        isRead: false,
        deliveryStatus: MessageDeliveryStatus.sent,
      );
    }

    final timestampValue = map['timestamp'];
    final parsedTimestamp = timestampValue is Timestamp
        ? timestampValue.toDate()
        : timestampValue is String
            ? DateTime.tryParse(timestampValue)?.toUtc()
            : DateTime.now().toUtc();

    return Message(
      messageId: map['messageId']?.toString() ?? messageId,
      senderId: map['senderId']?.toString() ?? '',
      senderName: map['senderName']?.toString() ?? 'Unknown',
      senderPhone: map['senderPhone']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      type: MessageTypeExtension.fromValue(map['type']?.toString()),
      priority: MessagePriorityExtension.fromValue(map['priority']?.toString()),
      timestamp: parsedTimestamp ?? DateTime.now().toUtc(),
      latitude: _parseDouble(map['latitude']),
      longitude: _parseDouble(map['longitude']),
      recipientId: map['recipientId']?.toString(),
      isRead: map['isRead'] == true,
      deliveryStatus: MessageDeliveryStatusExtension.fromValue(map['deliveryStatus']?.toString()),
    );
  }

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return Message.fromMap(snapshot.data(), messageId: snapshot.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhone': senderPhone,
      'message': message,
      'type': type.value,
      'priority': priority.value,
      'timestamp': Timestamp.fromDate(timestamp.toUtc()),
      'latitude': latitude,
      'longitude': longitude,
      'recipientId': recipientId,
      'isRead': isRead,
      'deliveryStatus': deliveryStatus.value,
    }..removeWhere((_, dynamic value) => value == null);
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  Message copyWith({
    String? messageId,
    String? senderId,
    String? senderName,
    String? senderPhone,
    String? message,
    MessageType? type,
    MessagePriority? priority,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? recipientId,
    bool? isRead,
    MessageDeliveryStatus? deliveryStatus,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderPhone: senderPhone ?? this.senderPhone,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      recipientId: recipientId ?? this.recipientId,
      isRead: isRead ?? this.isRead,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }

  static bool validateMessage(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
