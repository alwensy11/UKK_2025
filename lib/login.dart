import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kasir_pl1/admin/beranda_admin_aja.dart';
import 'package:kasir_pl1/petugas/beranda_petugas_aja.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HalamanLogin()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ClipRRect(
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.cover,
          height: 400.0,
          width: 400.0,
        ),
      )),
    );
  }
}

class HalamanLogin extends StatelessWidget {
  HalamanLogin({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Login() async {
      if (_formKey.currentState?.validate() ?? false) {
        try {
          var result = await Supabase.instance.client
              .from('user')
              .select()
              .eq('username', _usernameController.text)
              .eq('password', _passwordController.text)
              .single();

          if (result != result.isEmpty) {
            String role = result['role'];

            if (role == 'administrator') {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AwalBerandaAdmin()));

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Login berhasil'),
                  backgroundColor: Colors.pinkAccent.shade100));
            } else if (role == 'petugas') {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AwalBerandaPetugas()));

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Login berhasil'),
                  backgroundColor: Colors.pinkAccent.shade100));
            }
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Username atau password salah'),
            backgroundColor: Colors.pinkAccent.shade100,
          ));
        }
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 75.0, left: 20.0, right: 20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ClipRRect(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 250.0,
                    width: 250.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.shade100),
                  onPressed: () {
                    Login();
                  },
                  child: Text(
                    'LOGIN',
                    style: GoogleFonts.comfortaa(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
