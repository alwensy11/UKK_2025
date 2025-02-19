import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kasir_pl1/admin/user/user_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditUserAdmin extends StatefulWidget {
  final String username;
  final String password;
  final String role;

  const EditUserAdmin({
    Key? key,
    required this.username,
    required this.password,
    required this.role,
  }) : super(key: key);

  @override
  State<EditUserAdmin> createState() => _EditUserAdminState();
}

class _EditUserAdminState extends State<EditUserAdmin> {
  String? _pilihRole;
  final List<String> _roles = ['administrator', 'petugas'];

  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);

    passwordController = TextEditingController(
        text: utf8.decode(base64Decode(widget.password)));

    _pilihRole = widget.role;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> EditUser() async {
    // Hash password dengan Base64 sebelum menyimpan
    String hashedPassword = base64Encode(utf8.encode(passwordController.text));

    final response = await Supabase.instance.client
        .from('user')
        .update({
          'username': usernameController.text,
          'password': hashedPassword,
          'role': _pilihRole
        })
        .eq('username', widget.username)
        .select();

    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal memperbarui user'),
        backgroundColor: Colors.pinkAccent.shade100,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User berhasil diperbarui'),
        backgroundColor: Colors.pinkAccent.shade100,
      ));
    }
  }

  Future<void> simpanUser() async {
    if (_formKey.currentState!.validate()) {
      await EditUser();
      Navigator.pop(context, {
        'username': usernameController.text,
        'password': passwordController.text,
        'role': _pilihRole,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.white,
        title: Text('Edit User'),
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
                      child: Text('$value'),
                    );
                  }).toList(),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.shade100),
                  onPressed: () {
                    simpanUser();
                  },
                  child: Text(
                    'Simpan',
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