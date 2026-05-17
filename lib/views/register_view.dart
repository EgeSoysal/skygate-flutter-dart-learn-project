// lib/views/register_view.dart

import 'package:flutter/material.dart';
import 'package:skygate/constants/routes.dart';
import 'package:skygate/services/auth/auth_exceptions.dart';
import 'package:skygate/services/auth/auth_service.dart';
import 'package:skygate/utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('SkyGate - Personel Kayıt'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column( // Hata veren yer burasıydı, 'child' olarak düzeltildi.
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Kurumsal Personel E-postası',
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
                  // Sahte servisimiz üzerinden kaydı tetikliyoruz
                  await AuthService.fromMock().createUser(
                    email: email,
                    packagePassword: password,
                  );
                  
                  devtools.log('Personel başarıyla kaydedildi: $email');
                  
                  if (!context.mounted) return;
                  // Kayıt başarılı olunca personeli direkt doğrulama ekranına şutluyoruz
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                    context,
                    'Bu personel e-postası sistemde zaten mevcut.',
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    'Geçersiz e-posta formatı. Lütfen kontrol edin.',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Sistem hatası: Kayıt işlemi tamamlanamadı.',
                  );
                }
              },
              child: const Text('Sisteme Kaydol'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Zaten kayıtlı mısınız? Personel Girişi Yapın'),
            )
          ],
        ),
      ),
    );
  }
}