import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _auth = AuthService();
  AppUser? _user;
  AppUser? get user => _user;

  Stream<AppUser?> get userStream => _auth.user;

  AuthProvider() {
    _auth.user.listen((firebaseUser) {
      _user = firebaseUser;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    _user = await _auth.signIn(email, password);
    notifyListeners();
  }

  Future<void> register(String email, String password, String role, String lang) async {
    _user = await _auth.register(email, password, UserRole.values.firstWhere((r) => r.toString().contains(role)), lang);
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.logout();
    _user = null;
    notifyListeners();
  }
}
