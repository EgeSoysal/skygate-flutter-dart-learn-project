// lib/services/auth/auth_user.dart

import 'package:meta/meta.dart';

@immutable
class AuthUser {
  final String email;
  final bool isEmailVerified;

  const AuthUser({
    required this.email,
    required this.isEmailVerified,
  });
}