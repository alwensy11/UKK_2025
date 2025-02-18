import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_pl1/petugas/pelanggan/pelanggan_petugas.dart';
import 'package:kasir_pl1/petugas/penjualan/penjualan_petugas.dart';
import 'package:kasir_pl1/petugas/penjualan/riwayat_petugas.dart';
import 'package:kasir_pl1/petugas/produk/produk_petugas.dart';
import 'package:kasir_pl1/petugas/user/user_petugas.dart';
import 'package:kasir_pl1/login.dart';

class HalamanBerandaPetugas extends StatefulWidget {
  const HalamanBerandaPetugas({super.key});

  @override
  State<HalamanBerandaPetugas> createState() => _HalamanBerandaPetugasState();
}

class _HalamanBerandaPetugasState extends State<HalamanBerandaPetugas> {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserPetugas()));
              },
            ),
            ListTile(
              title: Text('Produk',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProdukPetugas()));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RiwayatPetugas()));
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
