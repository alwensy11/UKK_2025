import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir_pl1/admin/user/insert_user_admin.dart';
// import 'package:kasir_pl1/admin/user/edit_user_admin.dart';

class UserAdmin extends StatefulWidget {
  const UserAdmin({super.key});

  @override
  State<UserAdmin> createState() => _UserAdminState();
}

class _UserAdminState extends State<UserAdmin> {
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

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => UserAdmin()));
  }

  Future<void> _deleteUsers(int id) async {
    try {
      await Supabase.instance.client.from('user').delete().eq('UserID', id);
      fetchUsers();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User tidak ditemukan : $e')));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.white,
      ),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
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
                      children: [
                        IconButton(
                            onPressed: () async {
                              //   final result = await Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => EditUserAdmin(
                              //               username: user['username'],
                              //               password: user['password'])));

                              // if (result != null) {
                              //   setState(() {
                              //     users[index] = {
                              //       'username' = result['username'],
                              //       'password' = result['password']
                              //     };
                              //   });
                              // }
                            },
                            icon: Icon(Icons.edit),
                            color: Colors.blue),
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
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => InsertUserAdmin()));
            if (result == true) {
              fetchUsers();
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent.shade100),
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
