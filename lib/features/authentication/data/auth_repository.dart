import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseAuthRepository {
  Future<void> signInAnonymously();
  Future<void> signOut();
  Stream<User?> get authStateChanges;
  User? get currentUser;
}

class AuthRepository implements BaseAuthRepository {
  final Reader _read;

  const AuthRepository(this._read);

  @override
  //TODO: implement authStateChanges
  Stream<User?> get authStateChanges =>
      throw UnimplementedError(); // _read(firebaseAuthProvider).authStateChanges(); // 1
  // _read(firebaseAuthProvider).authStateChanges(); // 1

  // AuthRepository({FirebaseAuth? firebaseAuth})
  //     : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // @override
  // Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // @override
  // User? get currentUser => _firebaseAuth.currentUser;

  // @override
  // Future<void> signInAnonymously() async {
  //   await _firebaseAuth.signInAnonymously();
  // }

  // @override
  // Future<void> signOut() async {
  //   await _firebaseAuth.signOut();
  // }
}

// abstract class AuthRepository {
//   Future<UserCredential> signInWithGoogle();
//   Future<void> signOut();
//   Stream<User> get user;
// }

// class AuthRepository extends BaseAuthRepository {
//   final FirebaseAuth _firebaseAuth;

//   AuthRepository({FirebaseAuth? firebaseAuth})
//       : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

//   @override
//   Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

//   @override
//   User? get currentUser => _firebaseAuth.currentUser;

//   @override
//   Future<void> signInAnonymously() async {
//     await _firebaseAuth.signInAnonymously();
//   }

//   @override
//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }
// }
