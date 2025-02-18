import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir_pl1/petugas/beranda_petugas.dart';
import 'package:kasir_pl1/petugas/pelanggan/pelanggan_petugas.dart';
import 'package:kasir_pl1/petugas/penjualan/penjualan_petugas.dart';
import 'package:kasir_pl1/petugas/penjualan/riwayat_petugas.dart';
import 'package:kasir_pl1/petugas/produk/produk_petugas.dart';
import 'package:kasir_pl1/login.dart';

class UserPetugas extends StatefulWidget {
  const UserPetugas({super.key});

  @override
  State<UserPetugas> createState() => _UserPetugasState();
}

class _UserPetugasState extends State<UserPetugas> {
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
                        builder: (context) => HalamanBerandaPetugas()));
              },
            ),
            ListTile(
              title: Text('User',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserPetugas()));
              },
            ),
            ListTile(
              title: Text('Produk',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProdukPetugas()));
              },
            ),
            ListTile(
              title: Text('Pelanggan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PelangganPetugas()));
              },
            ),
            ListTile(
              title: Text('Penjualan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PenjualanPetugas()));
              },
            ),
            ListTile(
              title: Text('Riwayat Penjualan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RiwayatPetugas()));
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
        ),),
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
                  ),
                );
              }),
    );
  }
}
