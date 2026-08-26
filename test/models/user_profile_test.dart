import 'package:flutter_test/flutter_test.dart';
import 'package:tracenet/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('round-trips values through map serialization', () {
      final profile = UserProfile(
        uid: 'uid-1',
        name: 'Ada Lovelace',
        phone: '+1234567890',
        email: 'ada@example.com',
        bloodGroup: 'AB+',
        medicalInfo: 'Allergic to penicillin',
        emergencyContacts: ['+1111111111', '+2222222222'],
        createdAt: DateTime(2026, 7, 23),
      );

      final map = profile.toMap();
      final decoded = UserProfile.fromMap(map, uid: 'uid-1');

      expect(decoded.uid, 'uid-1');
      expect(decoded.name, 'Ada Lovelace');
      expect(decoded.emergencyContacts, hasLength(2));
      expect(decoded.bloodGroup, 'AB+');
      expect(decoded.medicalInfo, 'Allergic to penicillin');
    });

    test('copyWith updates only provided values', () {
      final profile = UserProfile(uid: 'uid-1', name: 'Ada');
      final updated = profile.copyWith(name: 'Grace');

      expect(updated.uid, 'uid-1');
      expect(updated.name, 'Grace');
      expect(updated.email, isNull);
    });
  });
}
