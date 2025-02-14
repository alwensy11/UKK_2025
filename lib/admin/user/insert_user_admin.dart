import 'package:flutter/material.dart';
import 'package:kasir_pl1/admin/beranda_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertUserAdmin extends StatefulWidget {
  const InsertUserAdmin({super.key});

  @override
  State<InsertUserAdmin> createState() => _InsertUserAdminState();
}

class _InsertUserAdminState extends State<InsertUserAdmin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> InsertUser() async {
      String username = usernameController.text.trim();
      String password = passwordController.text.trim();
      String role = roleController.text.trim();

      if (username.isNotEmpty && password.isNotEmpty && role.isNotEmpty) {
        final response = await Supabase.instance.client
            .from('user')
            .insert({'username': username, 'password': password, 'role': role});

        if (response == null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HalamanBerandaAdmin()));
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
                
                TextFormField(
                  controller: usernameController,
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
                  controller: passwordController,
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
                    InsertUser();
                  },
                  child: Text(
                    'Tambah',
                    style: TextStyle(color: Colors.white),
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
