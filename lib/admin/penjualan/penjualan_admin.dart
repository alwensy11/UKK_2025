import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir_pl1/admin/penjualan/insert_penjualan_admin.dart';

class PenjualanAdmin extends StatefulWidget {
  const PenjualanAdmin({super.key});

  @override
  State<PenjualanAdmin> createState() => _PenjualanAdminState();
}

class _PenjualanAdminState extends State<PenjualanAdmin> {
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

  Widget build(BuildContext context) {
    return Scaffold(
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
                    builder: (context) => InsertPenjualanAdmin()));
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
