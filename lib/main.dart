// lib/main.dart

import 'package:flutter/material.dart';
import 'package:skygate/constants/routes.dart';
import 'package:skygate/services/auth/auth_service.dart';
import 'package:skygate/views/flight_logs_view.dart';
import 'package:skygate/views/login_view.dart';
import 'package:skygate/views/register_view.dart';
import 'package:skygate/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyGate Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      // Uygulama açılışında ana üs (Home) olarak HomePage süzgecini belirliyoruz
      home: const HomePage(),
      // Chapter 20: Merkezi Rota Yönetimi Kataloğumuz
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        flightLogsRoute: (context) => const FlightLogsView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Sahte kimlik doğrulama servisimizin başlangıç yüklemesini bekliyoruz
      future: AuthService.fromMock().initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final user = AuthService.fromMock().currentUser;
          
          if (user != null) {
            // Chapter 23: E-posta doğrulama akış kontrolü (Auth Flow Guard)
            if (user.isEmailVerified) {
              return const FlightLogsView();
            } else {
              return const VerifyEmailView();
            }
          } else {
            // Sisteme giriş yapmış personel yoksa doğrudan giriş kapısına
            return const LoginView();
          }
        } else {
          // Servis initialize edilirken havacılık temalı bir yüklenme ekranı
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            ),
          );
        }
      },
    );
  }
}