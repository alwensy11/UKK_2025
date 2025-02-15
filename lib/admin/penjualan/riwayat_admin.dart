import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatAdmin extends StatefulWidget {
  const RiwayatAdmin({super.key});

  @override
  State<RiwayatAdmin> createState() => _RiwayatAdminState();
}

class _RiwayatAdminState extends State<RiwayatAdmin> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await Supabase.instance.client.from('user').select();

    setState(() {
      users = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _deleteUsers(int id) async {
    try {
      await Supabase.instance.client.from('user').delete().eq('UserID', id);
      fetchUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User tidak ditemukan : $e'),
          backgroundColor: Colors.pinkAccent.shade100));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.pinkAccent.shade100, blurRadius: 10.0)
                      ]),
                  child: ListTile(
                    title: Text(
                      user['username'] ?? 'Tidak ada username',
                      style:
                          GoogleFonts.happyMonkey(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user['role'] ?? 'Tidak ada role'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              _deleteUsers(user['UserID']);
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red)
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
