import 'package:cloud_firestore/cloud_firestore.dart';

/// User profile stored in Firestore for TraceNet authentication users.
class UserProfile {
  final String uid;
  final String? name;
  final String? phone;
  final String? email;
  final String? bloodGroup;
  final String? medicalInfo;
  final List<String>? emergencyContacts;
  final Map<String, dynamic>? lastKnownLocation;
  final DateTime? createdAt;

  const UserProfile({
    required this.uid,
    this.name,
    this.phone,
    this.email,
    this.bloodGroup,
    this.medicalInfo,
    this.emergencyContacts,
    this.lastKnownLocation,
    this.createdAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic>? map, {required String uid}) {
    if (map == null) {
      return UserProfile(uid: uid);
    }

    final rawLocation = map['lastKnownLocation'];
    final locationMap = rawLocation is GeoPoint
        ? {
            'latitude': rawLocation.latitude,
            'longitude': rawLocation.longitude,
          }
        : rawLocation is Map
            ? Map<String, dynamic>.from(rawLocation)
            : null;

    return UserProfile(
      uid: uid,
      name: map['name']?.toString(),
      phone: map['phone']?.toString(),
      email: map['email']?.toString(),
      bloodGroup: map['bloodGroup']?.toString(),
      medicalInfo: map['medicalInfo']?.toString(),
      emergencyContacts: map['emergencyContacts'] is List
          ? List<String>.from(
              (map['emergencyContacts'] as List).whereType<String>(),
            )
          : null,
      lastKnownLocation: locationMap,
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  factory UserProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return UserProfile.fromMap(snapshot.data(), uid: snapshot.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'bloodGroup': bloodGroup,
      'medicalInfo': medicalInfo,
      'emergencyContacts': emergencyContacts,
      'lastKnownLocation': lastKnownLocation,
      'createdAt': createdAt?.toUtc().toIso8601String(),
    }..removeWhere((_, value) => value == null);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'bloodGroup': bloodGroup,
      'medicalInfo': medicalInfo,
      'emergencyContacts': emergencyContacts,
      'lastKnownLocation': lastKnownLocation,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!.toUtc()) : null,
    }..removeWhere((_, value) => value == null);
  }

  UserProfile copyWith({
    String? uid,
    String? name,
    String? phone,
    String? email,
    String? bloodGroup,
    String? medicalInfo,
    List<String>? emergencyContacts,
    Map<String, dynamic>? lastKnownLocation,
    DateTime? createdAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }
}
