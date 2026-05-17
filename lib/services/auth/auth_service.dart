// lib/services/auth/auth_service.dart

import 'package:skygate/services/auth/auth_provider.dart';
import 'package:skygate/services/auth/auth_user.dart';
import 'package:skygate/services/auth/mock_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  
  const AuthService(this.provider);

  // Mimarinin sihirli noktası: Fabrika (factory) constructor ile 
  // dış dünyaya çaktırmadan arkaya MockAuthProvider motorunu bağlıyoruz.
  factory AuthService.fromMock() => AuthService(MockAuthProvider());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String packagePassword,
  }) =>
      provider.logIn(
        email: email,
        packagePassword: packagePassword,
      );

  @override
  Future<AuthUser> createUser({
    required String email,
    required String packagePassword,
  }) =>
      provider.createUser(
        email: email,
        packagePassword: packagePassword,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}