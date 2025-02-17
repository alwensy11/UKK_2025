import 'package:flutter/material.dart';
import 'package:kasir_pl1/petugas/produk/produk_petugas.dart';
import 'package:kasir_pl1/petugas/user/user_petugas.dart';
import 'package:kasir_pl1/petugas/pelanggan/pelanggan_petugas.dart';
import 'package:kasir_pl1/petugas/penjualan/penjualan_petugas.dart';
import 'package:kasir_pl1/petugas/penjualan/riwayat_petugas.dart';
import 'package:kasir_pl1/login.dart';

class HalamanBerandaPetugas extends StatefulWidget {
  const HalamanBerandaPetugas({super.key});

  @override
  State<HalamanBerandaPetugas> createState() => _HalamanBerandaPetugasState();
}

class _HalamanBerandaPetugasState extends State<HalamanBerandaPetugas> {
  // Menyimpan indeks halaman yang dipilih
  int _selectedIndex = 0;

  // Daftar halaman untuk Bottom Navigation
  final List<Widget> _pages = [
    UserPetugas(), // Halaman User Admin
    ProdukPetugas(), // Halaman Produk Admin
    PelangganPetugas(),
    PenjualanPetugas(),
    RiwayatPetugas(),
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
