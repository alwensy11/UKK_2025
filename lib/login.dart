import 'package:flutter/material.dart';
import 'package:kasir_pl1/admin/beranda_admin.dart';
import 'package:kasir_pl1/petugas/beranda_petugas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HalamanLogin extends StatelessWidget {
  HalamanLogin({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Login() async {
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HalamanBerandaAdmin()));

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Login berhasil'),
                backgroundColor: Colors.blueAccent));
          } else if (role == 'petugas') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HalamanBerandaPetugas()));

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Login berhasil'),
                backgroundColor: Colors.blueAccent));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Username atau password salah'),
              backgroundColor: Colors.blueAccent,
            ));
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Terjadi kesalahan, silahkan coba lagi'),
          backgroundColor: Colors.blueAccent,
        ));
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
        child: Center(
          child: Column(
            children: [
              ClipRRect(
                child: Image.asset('assets/logo.png'),
              ),
              SizedBox(height: 30.0),
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
                    backgroundColor: Colors.blueAccent),
                onPressed: () {
                  Login();
                },
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
