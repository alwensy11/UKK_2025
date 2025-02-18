import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir_pl1/admin/beranda_admin.dart';
import 'package:kasir_pl1/admin/pelanggan/pelanggan_admin.dart';
import 'package:kasir_pl1/admin/penjualan/penjualan_admin.dart';
import 'package:kasir_pl1/admin/penjualan/riwayat_admin.dart';
import 'package:kasir_pl1/admin/produk/produk_admin.dart';
import 'package:kasir_pl1/login.dart';
import 'package:kasir_pl1/admin/user/insert_user_admin.dart';
import 'package:kasir_pl1/admin/user/edit_user_admin.dart';

class UserAdmin extends StatefulWidget {
  const UserAdmin({super.key});

  @override
  State<UserAdmin> createState() => _UserAdminState();
}

class _UserAdminState extends State<UserAdmin> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    fetchUsers();
    searchController.addListener(_searchUsers); 
  }

  Future<void> fetchUsers() async {
    final response = await Supabase.instance.client.from('user').select();

    setState(() {
      users = List<Map<String, dynamic>>.from(response);
      filteredUsers = List.from(users); 
    });
  }

   Future<void> _searchUsers() async {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredUsers = users.where((user) {
        final username = user['username'].toLowerCase();
        return username.contains(query); 
      }).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              child: ClipRRect(
                child: Image.asset('assets/logo.png'),
              ),
            ),
            ListTile(
              title: Text('Beranda',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HalamanBerandaAdmin()));
              },
            ),
            ListTile(
              title: Text('User',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserAdmin()));
              },
            ),
            ListTile(
              title: Text('Produk',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProdukAdmin()));
              },
            ),
            ListTile(
              title: Text('Pelanggan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PelangganAdmin()));
              },
            ),
            ListTile(
              title: Text('Penjualan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PenjualanAdmin()));
              },
            ),
            ListTile(
              title: Text('Riwayat Penjualan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RiwayatAdmin()));
              },
            ),
            ListTile(
              title: Text('Logout',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HalamanLogin()));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.white,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Cari User...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.white),
          ),
        ),
      ),
      body: filteredUsers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
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
                    subtitle:
                        Text(user['role'], style: TextStyle(fontSize: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditUserAdmin(
                                            username: user['username'],
                                            password: user['password'],
                                            role: user['role'],
                                          )));

                              if (result != null) {
                                setState(() {
                                  filteredUsers[index] = {
                                    'username': result['username'],
                                    'password': result['password'],
                                    'role': result['role']
                                  };
                                });
                              }
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
