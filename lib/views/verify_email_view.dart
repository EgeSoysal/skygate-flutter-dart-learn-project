// lib/views/verify_email_view.dart

import 'package:flutter/material.dart';
import 'package:skygate/constants/routes.dart';
import 'package:skygate/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkyGate - Güvenlik Protokolü'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mark_email_unread_outlined,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 20),
            const Text(
              'E-posta Doğrulaması Gerekli!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Uçuş loglarına erişebilirliğiniz için kurumsal e-posta adresinize gönderilen güvenlik linkini onaylamanız gerekmektedir.',
              textAlign: TextAlign.center, // Hata veren yer burasıydı, 'TextAlign.center' olarak düzeltildi.
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                // Sahte doğrulama linkini tetikle (Hafızada isEmailVerified = true yapacak)
                await AuthService.fromMock().sendEmailVerification();
                devtools.log('Güvenlik onay e-postası (simüle) başarıyla gönderildi/onaylandı.');
                
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('E-posta başarıyla onaylandı! Giriş yapabilirsiniz.')),
                );
              },
              child: const Text('Doğrulama E-postası Gönder (Simüle Et)'),
            ),
            const SizedBox(height: 10),
            
            // CHAPTER 22: KULLANICININ STUCK KALMASINI ENGELLEYEN RESTART / GİRİŞE DÖNÜŞ BUTONU
            TextButton(
              onPressed: () async {
                // Oturumu kapatıp belleği temizliyoruz
                await AuthService.fromMock().logOut();
                devtools.log('Kullanıcı stuck durumundan çıkmak için sistemi restart etti.');
                
                if (!context.mounted) return;
                // Kullanıcıyı temiz bir şekilde en başa, yani login ekranına fırlatıyoruz
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Sistemi Yeniden Başlat (Giriş Ekranına Dön)'),
            )
          ],
        ),
      ),
    );
  }
}