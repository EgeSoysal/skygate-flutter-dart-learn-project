// lib/services/auth/auth_provider.dart

import 'package:skygate/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  
  AuthUser? get currentUser;
  
  Future<AuthUser> logIn({
    required String email,
    required String packagePassword,
  });
  
  Future<AuthUser> createUser({
    required String email,
    required String packagePassword,
  });
  
  Future<void> logOut();
  Future<void> sendEmailVerification();
}