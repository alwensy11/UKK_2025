import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_pl1/admin/pelanggan/pelanggan_admin.dart';
import 'package:kasir_pl1/admin/penjualan/penjualan_admin.dart';
import 'package:kasir_pl1/admin/penjualan/riwayat_admin.dart';
import 'package:kasir_pl1/admin/produk/produk_admin.dart';
import 'package:kasir_pl1/admin/user/user_admin.dart';
import 'package:kasir_pl1/login.dart';

class HalamanBerandaAdmin extends StatefulWidget {
  const HalamanBerandaAdmin({super.key});

  @override
  State<HalamanBerandaAdmin> createState() => _HalamanBerandaAdminState();
}

class _HalamanBerandaAdminState extends State<HalamanBerandaAdmin> {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserAdmin()));
              },
            ),
            ListTile(
              title: Text('Produk',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProdukAdmin()));
              },
            ),
            ListTile(
              title: Text('Pelanggan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PelangganAdmin()));
              },
            ),
            ListTile(
              title: Text('Penjualan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PenjualanAdmin()));
              },
            ),
            ListTile(
              title: Text('Riwayat Penjualan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RiwayatAdmin()));
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
            foregroundColor: Colors.white),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  child: Image.asset('assets/logo.png', fit: BoxFit.cover, height: 300.0, width: 300.0,),
                ),
                Text('Selamat Datang', style: GoogleFonts.lilitaOne(color: Colors.pinkAccent.shade100, fontWeight: FontWeight.bold, fontSize: 40),),
                Text(' Di Aplikasi Kasir Toko Donat', style: GoogleFonts.lilitaOne(color: Colors.pinkAccent.shade100, fontWeight: FontWeight.bold, fontSize: 25),)
              ],
            ),
          ),
        ));
  }
}
