// lib/views/flight_logs_view.dart

import 'package:flutter/material.dart';
import 'package:skygate/constants/routes.dart';
import 'package:skygate/enums/menu_action.dart';
import 'package:skygate/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

class FlightLogsView extends StatefulWidget {
  const FlightLogsView({super.key});

  @override
  State<FlightLogsView> createState() => _FlightLogsViewState();
}

class _FlightLogsViewState extends State<FlightLogsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkyGate - Uçuş Logları'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    await AuthService.fromMock().logOut();
                    devtools.log('Personel aktif vardiyayı kapatıp çıkış yaptı.');
                    
                    if (!context.mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Vardiyayı Kapat (Güvenli Çıkış)'),
                ),
              ];
            },
          )
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, size: 60, color: Colors.blueGrey),
            SizedBox(height: 16),
            Text(
              'Uçuş Bakım ve Operasyon Logları',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Erişim İzni: Onaylı Havacılık Personeli',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600), // Hata veren yer w600 olarak düzeltildi!
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Güvenli Çıkış Protokolü'),
        content: const Text('Aktif vardiyanızı sonlandırmak ve sistemden çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Vardiyayı Kapat'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}