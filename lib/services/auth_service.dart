import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();

  AppUser? _userFromFirebaseUser(User user) {
    return user.uid.isNotEmpty ? AppUser(id: user.uid, email: user.email ?? '', role: UserRole.local, language: null) : null;
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      // Fetch full user from Firestore
      return await _firestore.getUser(firebaseUser.uid);
    });
  }

  Future<AppUser?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(result.user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AppUser?> register(String email, String password, UserRole role, String lang) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        AppUser newUser = AppUser(id: result.user!.uid, email: email, role: role, language: lang);
        await _firestore.setUser(newUser);
        return newUser;
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future logout() async {
    await _auth.signOut();
  }
}
