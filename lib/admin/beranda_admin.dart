import 'package:flutter/material.dart';
import 'package:kasir_pl1/admin/produk/produk_admin.dart';
import 'package:kasir_pl1/admin/user/user_admin.dart';
import 'package:kasir_pl1/admin/pelanggan/pelanggan_admin.dart';
import 'package:kasir_pl1/admin/penjualan/penjualan_admin.dart';
import 'package:kasir_pl1/admin/penjualan/riwayat_admin.dart';
import 'package:kasir_pl1/login.dart';

class HalamanBerandaAdmin extends StatefulWidget {
  const HalamanBerandaAdmin({super.key});

  @override
  State<HalamanBerandaAdmin> createState() => _HalamanBerandaAdminState();
}

class _HalamanBerandaAdminState extends State<HalamanBerandaAdmin> {
  // Menyimpan indeks halaman yang dipilih
  int _selectedIndex = 0;

  // Daftar halaman untuk Bottom Navigation
  final List<Widget> _pages = [
    UserAdmin(), // Halaman User Admin
    ProdukAdmin(), // Halaman Produk Admin
    PelangganAdmin(),
    PenjualanAdmin(),
    RiwayatAdmin(),
  ];

  // Fungsi untuk menangani perubahan halaman saat item Bottom Navigation dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Mengubah halaman yang dipilih
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
          foregroundColor: Colors.white),
      body: _pages[
          _selectedIndex], // Menampilkan halaman yang dipilih berdasarkan indeks
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pinkAccent.shade100,
        fixedColor:  Colors.pinkAccent.shade100,
        unselectedItemColor: Colors.pinkAccent.shade100,
        currentIndex: _selectedIndex, // Menyimpan halaman yang aktif
        onTap: _onItemTapped, // Menangani klik item BottomNavigationBar
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cake),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Pelanggan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Penjualan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat Penjualan',
          ),
        ],
      ),
    );
  }
}
