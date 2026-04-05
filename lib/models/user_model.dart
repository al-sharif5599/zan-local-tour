import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { local, admin, guest, chwa }

class AppUser {
  final String id;
  final String email;
  final UserRole role;
  final String? language; // 'sw' or 'en'

  AppUser({
    required this.id,
    required this.email,
    required this.role,
    this.language,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      email: data['email'] ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.toString() == 'UserRole.${data['role']}',
      ),
      language: data['language'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'role': role.toString().split('.').last,
      'language': language,
    };
  }
}
