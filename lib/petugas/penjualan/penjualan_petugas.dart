import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir_pl1/petugas/penjualan/insert_penjualan_petugas.dart';
import 'package:kasir_pl1/petugas/beranda_petugas.dart';
import 'package:kasir_pl1/petugas/pelanggan/pelanggan_petugas.dart';
import 'package:kasir_pl1/petugas/penjualan/riwayat_petugas.dart';
import 'package:kasir_pl1/petugas/produk/produk_petugas.dart';
import 'package:kasir_pl1/petugas/user/user_petugas.dart';
import 'package:kasir_pl1/login.dart';

class PenjualanPetugas extends StatefulWidget {
  const PenjualanPetugas({super.key});

  @override
  State<PenjualanPetugas> createState() => _PenjualanPetugasState();
}

class _PenjualanPetugasState extends State<PenjualanPetugas> {
  List<Map<String, dynamic>> penjualans = [];

  @override
  void initState() {
    super.initState();
    fetchPenjualans();
  }

  Future<void> fetchPenjualans() async {
    final response = await Supabase.instance.client
        .from('penjualan')
        .select('*,pelanggan(*)');

    setState(() {
      penjualans = List<Map<String, dynamic>>.from(response);
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
          foregroundColor: Colors.white),
      body: penjualans.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: penjualans.length,
              itemBuilder: (context, index) {
                final penjualan = penjualans[index];
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
                      'Tanggal : ${penjualan['TanggalPenjualan']}',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Total Harga : ${penjualan['TotalHarga']}',
                              style: GoogleFonts.roboto(fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Nama : ${penjualan['pelanggan']['NamaPelanggan']}',
                              style: GoogleFonts.roboto(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.receipt),
                            color: Colors.grey),
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InsertPenjualanPetugas()));
            if (result == true) {
              fetchPenjualans();
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
