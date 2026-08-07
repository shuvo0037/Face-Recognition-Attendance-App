import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthError(e));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _db.collection('users').doc(credential.user!.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await credential.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthError(e));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthError(e));
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final user = currentUser;

    if (user == null) {
      throw Exception("User not logged in.");
    }

    return await _db.collection('users').doc(user.uid).get();
  }

  Future<String> getUserRole() async {
    final doc = await getUserData();

    if (!doc.exists) {
      throw Exception("User profile not found.");
    }

    return doc.data()?['role'] ?? '';
  }

  Future<String> getUserName() async {
    final doc = await getUserData();

    if (!doc.exists) {
      throw Exception("User profile not found.");
    }

    return doc.data()?['name'] ?? '';
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _getAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'User not found';

      case 'wrong-password':
        return 'Wrong password';

      case 'invalid-email':
        return 'Invalid email';

      case 'email-already-in-use':
        return 'Email already exists';

      case 'weak-password':
        return 'Password is too weak';

      case 'network-request-failed':
        return 'No internet connection';

      default:
        return e.message ?? 'Authentication failed';
    }
  }
}