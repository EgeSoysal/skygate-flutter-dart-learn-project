// lib/views/login_view.dart

import 'package:flutter/material.dart';
import 'package:skygate/constants/routes.dart';
import 'package:skygate/services/auth/auth_exceptions.dart';
import 'package:skygate/services/auth/auth_service.dart';
import 'package:skygate/utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkyGate - Personel Girişi'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Personel E-postası',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Güvenlik Şifresi',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  // Sahte servis üzerinden giriş kontrolü
                  final user = await AuthService.fromMock().logIn(
                    email: email,
                    packagePassword: password,
                  );
                  
                  devtools.log('Giriş denemesi başarılı: ${user.email}');

                  if (!context.mounted) return;

                  // CHAPTER 23 GÜVENLİK DUVARI: E-posta onaylanmamışsa engelle!
                  if (user.isEmailVerified) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      flightLogsRoute,
                      (route) => false,
                    );
                  } else {
                    devtools.log('Personel e-postası onaylı değil. Yönlendiriliyor...');
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                } on CrewMemberNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    'Sistemde bu e-posta adresiyle kayıtlı personel bulunamadı.',
                  );
                } on WrongCrewCredentialsAuthException {
                  await showErrorDialog(
                    context,
                    'Hatalı şifre. Lütfen güvenlik anahtarınızı kontrol edin.',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Kimlik doğrulama sırasında bir sistem hatası oluştu.',
                  );
                }
              },
              child: const Text('Giriş Yap'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Henüz kaydolmadınız mı? Buradan personel kaydı açın'),
            )
          ],
        ),
      ),
    );
  }
}