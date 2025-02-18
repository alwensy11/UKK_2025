import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir_pl1/petugas/beranda_petugas.dart';
import 'package:kasir_pl1/petugas/pelanggan/pelanggan_petugas.dart';
import 'package:kasir_pl1/petugas/penjualan/penjualan_petugas.dart';
import 'package:kasir_pl1/petugas/produk/produk_petugas.dart';
import 'package:kasir_pl1/petugas/user/user_petugas.dart';
import 'package:kasir_pl1/login.dart';

class RiwayatPetugas extends StatefulWidget {
  const RiwayatPetugas({super.key});

  @override
  State<RiwayatPetugas> createState() => _RiwayatPetugasState();
}

class _RiwayatPetugasState extends State<RiwayatPetugas> {
  List<Map<String, dynamic>> detail_penjualans = [];
  List<Map<String, dynamic>> penjualans = [];
  String? username;

  @override
  void initState() {
    super.initState();
    fetchRiwayatPenjualan();
    fetchUser();
  }

  // Fungsi untuk mengambil data penjualan
  Future<void> fetchRiwayatPenjualan() async {
    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .select('*,penjualan(*,pelanggan(*)),produk(*)');
      setState(() {
        detail_penjualans = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data penjualan: $e'),
          backgroundColor: Colors.pinkAccent.shade100,
        ),
      );
    }
  }

  // Fungsi untuk mengambil informasi user yang login
  Future<void> fetchUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        username =
            user.email; // Menampilkan email pengguna (atau bisa nama jika ada)
      });
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
      body: detail_penjualans.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: detail_penjualans.length,
              itemBuilder: (context, index) {
                final detail_penjualann = detail_penjualans[index];
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.shade100,
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                        'Nama : ${detail_penjualann['penjualan']['pelanggan']['NamaPelanggan']}',
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal : ${detail_penjualann['penjualan']['TanggalPenjualan']}',
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                        Text(
                            'Nama Produk : ${detail_penjualann['produk']['NamaProduk']}',
                            style: GoogleFonts.roboto(fontSize: 14)),
                        Text(
                          'Jumlah Produk : ${detail_penjualann['JumlahProduk'] ?? 'Jumlah Produk tidak tersedia'}',
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                        Text(
                          'Subtotal : Rp ${detail_penjualann['Subtotal'] ?? 'Subtotal tidak tersedia'}',
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                        Text(
                          'Nama Kasir : ${username}',
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
