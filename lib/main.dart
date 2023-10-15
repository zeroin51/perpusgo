import 'package:flutter/material.dart';
import 'package:perpusgo/dashboard/homeadmin.dart';
import 'package:perpusgo/page/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:perpusgo/page/loginpage.dart';
import 'firebase_options.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(PerpustakaanApp());
}

class PerpustakaanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perpustakaan Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
      '/home': (context) => PerpustakaanHomePage(), // Rute untuk PerpustakaanHomePage
      '/admin': (context) => AdminHomePage(), // Rute untuk PerpustakaanHomePage
      // Rute lainnya
    },
    );
  }
}