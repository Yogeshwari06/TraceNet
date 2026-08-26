import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

/// Authentication service responsible for Firebase Auth and Firestore profile work.
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  final FirebaseAuth? _firebaseAuth;
  final FirebaseFirestore? _firestore;

  FirebaseAuth get firebaseAuth => _firebaseAuth ?? FirebaseAuth.instance;
  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    String? bloodGroup,
    String? medicalInfo,
    required List<String> emergencyContacts,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(code: 'unknown', message: 'Registration failed.');
    }

    final profile = UserProfile(
      uid: user.uid,
      name: name.trim(),
      phone: phone.trim(),
      email: email.trim(),
      bloodGroup: bloodGroup?.trim().isNotEmpty == true ? bloodGroup!.trim() : null,
      medicalInfo: medicalInfo?.trim().isNotEmpty == true ? medicalInfo!.trim() : null,
      emergencyContacts: emergencyContacts
          .where((contact) => contact.trim().isNotEmpty)
          .map((contact) => contact.trim())
          .toList(),
      createdAt: DateTime.now().toUtc(),
    );

    await firestore.collection('Users').doc(user.uid).set(profile.toFirestore());
    return credential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  Future<void> forgotPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<User?> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }

  Future<List<UserProfile>> getUsers() async {
    final snapshot = await firestore.collection('Users').get();
    return snapshot.docs
        .map((doc) => UserProfile.fromMap(doc.data(), uid: doc.id))
        .toList();
  }

  Future<void> updateCurrentUserLocation({
    required double latitude,
    required double longitude,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      return;
    }

    await firestore.collection('Users').doc(user.uid).update({
      'lastKnownLocation': {
        'latitude': latitude,
        'longitude': longitude,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    });
  }

  Future<bool> checkLoginStatus() async {
    await firebaseAuth.authStateChanges().first;
    return firebaseAuth.currentUser != null;
  }
}
