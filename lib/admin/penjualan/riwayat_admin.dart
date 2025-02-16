import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatAdmin extends StatefulWidget {
  const RiwayatAdmin({super.key});

  @override
  State<RiwayatAdmin> createState() => _RiwayatAdminState();
}

class _RiwayatAdminState extends State<RiwayatAdmin> {
  List<Map<String, dynamic>> detail_penjualans = [];
  List<Map<String, dynamic>> penjualans = [];

  @override
  void initState() {
    super.initState();
    fetchRiwayatPenjualan();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                          style: GoogleFonts.roboto(
                              fontSize: 14),
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
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
