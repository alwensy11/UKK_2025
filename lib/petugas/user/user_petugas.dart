import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserPetugas extends StatefulWidget {
  const UserPetugas({super.key});

  @override
  State<UserPetugas> createState() => _UserPetugasState();
}

class _UserPetugasState extends State<UserPetugas> {
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
                      user['username'],
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(user['role'],
                        style: GoogleFonts.roboto(fontSize: 14)),
                  ),
                );
              }),
    );
  }
}
