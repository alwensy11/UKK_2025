import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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
  List<Map<String, dynamic>> detailpenjualans = [];

  @override
  void initState() {
    super.initState();
    fetchPenjualans();
    fetchDetailPenjualans();
  }

  Future<void> fetchPenjualans() async {
    final response = await Supabase.instance.client
        .from('penjualan')
        .select('*,pelanggan(*)');

    setState(() {
      penjualans = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> fetchDetailPenjualans() async {
    final response = await Supabase.instance.client
        .from('detailpenjualan')
        .select('*,produk(*)');

    setState(() {
      detailpenjualans = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<pw.MemoryImage> loadImageFromAsset(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List();
    final image = pw.MemoryImage(bytes);
    return image;
  }

  void DialogStruk(
      Map<String, dynamic> penjualan, Map<String, dynamic> detailpenjualan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Struk Penjualan', style: GoogleFonts.roboto()),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanggal: ${penjualan['TanggalPenjualan']}',
                    style: GoogleFonts.roboto(fontSize: 14)),
                Row(
                  children: [
                    Text('${detailpenjualan['produk']['NamaProduk']}',
                        style: GoogleFonts.roboto()),
                    Spacer(),
                    Text('${detailpenjualan['JumlahProduk']}',
                        style: GoogleFonts.roboto()),
                    Spacer(),
                    Text(
                      'Rp. ${detailpenjualan['Subtotal'] != null && detailpenjualan['Subtotal'] is double ? NumberFormat('#,###').format(detailpenjualan['Subtotal']) : 'Invalid'}',
                      style: GoogleFonts.roboto(),
                    ),
                  ],
                ),
                Text(
                  'Total Harga : Rp. ${penjualan['TotalHarga'] != null && penjualan['TotalHarga'] is double ? NumberFormat('#,###').format(penjualan['TotalHarga']) : 'Invalid'}',
                  style: GoogleFonts.roboto(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Tutup'),
            ),
            TextButton(
              onPressed: () async {
                final pdf = pw.Document();
                final image = await loadImageFromAsset('assets/logo.png');

                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) {
                      return pw.Column(
                        children: [
                          pw.Row(children: [
                            pw.ClipRRect(
                                child: pw.Image(image,
                                    fit: pw.BoxFit.cover,
                                    height: 200.0,
                                    width: 200.0)),
                            pw.Column(children: [
                              pw.Text('Struk',
                                  style: pw.TextStyle(fontSize: 40)),
                              pw.Text('Penjualan',
                                  style: pw.TextStyle(fontSize: 40)),
                            ]),
                          ]),
                          pw.Row(children: [
                            pw.Text('Tanggal : ${penjualan['TanggalPenjualan']}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15)),
                          ]),
                          for (var detailpenjualan in detailpenjualans)
                            pw.Row(
                              children: [
                                pw.Text(
                                    '${detailpenjualan['produk']['NamaProduk']}'),
                                pw.Spacer(),
                                pw.Text('${detailpenjualan['JumlahProduk']}'),
                                pw.Spacer(),
                                pw.Text(
                                  'Rp. ${detailpenjualan['Subtotal'] != null && detailpenjualan['Subtotal'] is double ? NumberFormat('#,###').format(detailpenjualan['Subtotal']) : 'Invalid'}',
                                ),
                              ],
                            ),
                          pw.SizedBox(height: 10),
                          pw.Row(children: [
                            pw.Text('Total Harga',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15)),
                            pw.Spacer(flex: 3),
                            pw.Text(
                              'Rp. ${penjualan['TotalHarga'] != null && penjualan['TotalHarga'] is double ? NumberFormat('#,###').format(penjualan['TotalHarga']) : 'Invalid'}',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 15),
                            )
                          ]),
                        ],
                      );
                    },
                  ),
                );

                await Printing.layoutPdf(
                  onLayout: (format) async => pdf.save(),
                );

                print('PDF generated and ready for printing.');
                Navigator.pop(context);
              },
              child: Text('Cetak'),
            ),
          ],
        );
      },
    );
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PelangganPetugas()));
              },
            ),
            ListTile(
              title: Text('Penjualan',
                  style: TextStyle(color: Colors.pinkAccent.shade100)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PenjualanPetugas()));
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
                final detailpenjualan = detailpenjualans[index];
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
                      'Nama : ${penjualan['pelanggan']['NamaPelanggan']}',
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Tanggal : ${penjualan['TanggalPenjualan']}',
                              style: GoogleFonts.roboto(fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Total Harga : Rp. ${penjualan['TotalHarga'] != null && penjualan['TotalHarga'] is double ? NumberFormat('#,###').format(penjualan['TotalHarga']) : 'Invalid'}',
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
                          onPressed: () =>
                              DialogStruk(penjualan, detailpenjualan),
                          icon: Icon(Icons.receipt),
                          color: Colors.grey,
                        ),
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
