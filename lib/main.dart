import 'package:flutter/material.dart';
import 'package:kasir_pl1/admin/beranda_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:kasir_pl1/login.dart';

Future<void> main() async {
  await Supabase.initialize(
      url: 'https://gcbzndnojivqfaknbqfb.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdjYnpuZG5vaml2cWZha25icWZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDg3NDUsImV4cCI6MjA1NDk4NDc0NX0.Ug_fjMZ-vFuHL_hYRnqa-kvQXBcySVyKZ9DOc2sh6d8');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HalamanBerandaAdmin(),
    );
  }
}
