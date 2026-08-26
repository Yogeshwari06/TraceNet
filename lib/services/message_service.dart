import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message.dart';
import '../models/user_profile.dart';

class MessageService {
  MessageService({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _firebaseAuth;

  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;
  FirebaseAuth get firebaseAuth => _firebaseAuth ?? FirebaseAuth.instance;

  String? get currentUserId => firebaseAuth.currentUser?.uid;

  Future<UserProfile> _loadCurrentUserProfile() async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'unauthenticated', message: 'You must be signed in.');
    }

    final doc = await firestore.collection('Users').doc(user.uid).get();
    if (doc.exists && doc.data() != null) {
      return UserProfile.fromMap(doc.data(), uid: user.uid);
    }

    return UserProfile(
      uid: user.uid,
      name: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!.trim()
          : user.email?.split('@').first ?? 'TraceNet user',
      phone: null,
      email: user.email,
      createdAt: DateTime.now().toUtc(),
    );
  }

  Future<Message> sendMessage({
    required String message,
    MessageType type = MessageType.normal,
    MessagePriority priority = MessagePriority.medium,
    String? recipientId,
    double? latitude,
    double? longitude,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'unauthenticated', message: 'You must be signed in to send a message.');
    }

    if (!Message.validateMessage(message)) {
      throw const FormatException('Message cannot be empty.');
    }

    final profile = await _loadCurrentUserProfile();
    final messageId = firestore.collection('Messages').doc().id;

    final newMessage = Message(
      messageId: messageId,
      senderId: user.uid,
      senderName: profile.name?.trim().isNotEmpty == true
          ? profile.name!
          : user.email?.split('@').first ?? 'TraceNet user',
      senderPhone: profile.phone ?? '',
      message: message.trim(),
      type: type,
      priority: priority,
      timestamp: DateTime.now().toUtc(),
      latitude: latitude,
      longitude: longitude,
      recipientId: recipientId,
      isRead: recipientId == null || recipientId == user.uid,
      deliveryStatus: MessageDeliveryStatus.sending,
    );

    await firestore.collection('Messages').doc(messageId).set(newMessage.toFirestore());

    final sentMessage = newMessage.copyWith(
      deliveryStatus: MessageDeliveryStatus.sent,
      isRead: recipientId == null || recipientId == user.uid,
    );

    await firestore.collection('Messages').doc(messageId).update(sentMessage.toFirestore());
    return sentMessage;
  }

  Future<Message> sendEmergencyMessage({
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

  Future<Message> sendSOSMessage({
    required String message,
    double? latitude,
    double? longitude,
  }) async {
    return sendMessage(
      message: message,
      type: MessageType.sos,
      priority: MessagePriority.critical,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<List<Message>> getMessages() async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'unauthenticated', message: 'You must be signed in.');
    }

    final snapshot = await firestore
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .get();

    final messages = snapshot.docs
        .map((doc) => Message.fromMap(doc.data(), messageId: doc.id))
        .where((message) {
          if (message.senderId == user.uid) {
            return true;
          }
          if (message.recipientId == null) {
            return true;
          }
          return message.recipientId == user.uid;
        })
        .toList();

    return messages;
  }

  Stream<List<Message>> watchMessages() {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return firestore
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Message.fromMap(doc.data(), messageId: doc.id))
              .where((message) {
                if (message.senderId == user.uid) {
                  return true;
                }
                if (message.recipientId == null) {
                  return true;
                }
                return message.recipientId == user.uid;
              })
              .toList();
        });
  }

  Future<void> markMessageAsRead(String messageId) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'unauthenticated', message: 'You must be signed in.');
    }

    final snapshot = await firestore.collection('Messages').doc(messageId).get();
    if (!snapshot.exists) {
      return;
    }

    final message = Message.fromMap(snapshot.data(), messageId: snapshot.id);
    if (message.recipientId != null && message.recipientId != user.uid && message.senderId != user.uid) {
      return;
    }

    await firestore.collection('Messages').doc(messageId).update({'isRead': true});
  }

  Future<Message?> getMessageById(String messageId) async {
    final snapshot = await firestore.collection('Messages').doc(messageId).get();
    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return Message.fromMap(snapshot.data(), messageId: snapshot.id);
  }

  Future<void> deleteMessage(String messageId) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'unauthenticated', message: 'You must be signed in.');
    }

    final snapshot = await firestore.collection('Messages').doc(messageId).get();
    if (!snapshot.exists) {
      return;
    }

    final message = Message.fromMap(snapshot.data(), messageId: snapshot.id);
    if (message.senderId != user.uid) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
        message: 'You can only delete your own messages.',
      );
    }

    await firestore.collection('Messages').doc(messageId).delete();
  }
}
