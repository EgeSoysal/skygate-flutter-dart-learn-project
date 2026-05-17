// lib/services/auth/mock_auth_provider.dart

import 'package:skygate/services/auth/auth_exceptions.dart';
import 'package:skygate/services/auth/auth_provider.dart';
import 'package:skygate/services/auth/auth_user.dart';

class MockAuthProvider implements AuthProvider {
  // Bellek içi sahte personel veritabanı: E-posta -> Şifre
  static final Map<String, String> _mockDb = {};
  
  // E-posta doğrulama durum takipçisi: E-posta -> Doğrulandı mı?
  static final Map<String, bool> _verificationDb = {};
  
  static AuthUser? _user;

  @override
  Future<void> initialize() async {
    // Firebase'in açılışındaki o ufak yüklenme gecikmesini simüle ediyoruz
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String packagePassword,
  }) async {
    // Ağ gecikmesi simülasyonu (UX için kritik)
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (!_mockDb.containsKey(email)) {
      throw CrewMemberNotFoundAuthException();
    }
    if (_mockDb[email] != packagePassword) {
      throw WrongCrewCredentialsAuthException();
    }
    
    final isVerified = _verificationDb[email] ?? false;
    _user = AuthUser(email: email, isEmailVerified: isVerified);
    return _user!;
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String packagePassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_mockDb.containsKey(email)) {
      throw EmailAlreadyInUseAuthException();
    }
    if (!email.contains('@') || email.length < 5) {
      throw InvalidEmailAuthException();
    }

    // Sahte veritabanımıza personeli kaydet
    _mockDb[email] = packagePassword;
    // İlk kayıt olduğunda Firebase gibi "onaysız" başlasın
    _verificationDb[email] = false; 
    
    _user = AuthUser(email: email, isEmailVerified: false);
    return _user!;
  }

  @override
  Future<void> logOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_user == null) throw GenericAuthException();
    
    // E-posta doğrulama butonuna basıldığında durumu hafızada true yapıyoruz
    _verificationDb[_user!.email] = true;
    
    // Kullanıcı nesnesini güncellenmiş haliyle yeniden türetiyoruz (Immutable kuralı)
    _user = AuthUser(email: _user!.email, isEmailVerified: true);
  }
}