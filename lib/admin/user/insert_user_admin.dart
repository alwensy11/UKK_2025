import 'package:flutter/material.dart';
import 'package:kasir_pl1/admin/user/user_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertUserAdmin extends StatefulWidget {
  const InsertUserAdmin({super.key});

  @override
  State<InsertUserAdmin> createState() => _InsertUserAdminState();
}

class _InsertUserAdminState extends State<InsertUserAdmin> {
  String? _pilihRole;

  final List<String> _roles = ['administrator', 'petugas'];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> InsertUser() async {
      if (_formKey.currentState?.validate() ?? false) {
        String username = usernameController.text;
        String password = passwordController.text;

        if (username.isEmpty || password.isEmpty || _roles.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Semua wajib diisi'),
            backgroundColor: Colors.pinkAccent.shade100,
          ));
          return;
        }

        final cekUsername = await Supabase.instance.client
            .from('user')
            .select()
            .eq('username', username)
            .single();

        if (cekUsername.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('User sudah terdaftar'),
            backgroundColor: Colors.pinkAccent.shade100,
          ));
        } else {
          if (username.isNotEmpty && password.isNotEmpty && _roles.isNotEmpty) {
            final response = await Supabase.instance.client
                .from('user')
                .insert({
              'username': username,
              'password': password,
              'role': _pilihRole
            });

            if (response == null) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserAdmin()));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('User berhasil ditambahkan'),
                backgroundColor: Colors.pinkAccent.shade100,
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error: ${response.error!.message}'),
                  backgroundColor: Colors.pinkAccent.shade100));
            }
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.white,
        title: Text('Tambah User'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 75.0, left: 30.0, right: 30.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
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
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Pilih Role'),
                  value: _pilihRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      _pilihRole = newValue;
                    });
                  },
                  items: _roles.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('${value}'),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Role wajib diisi';
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

extension on PostgrestMap {
  get error => null;
}
