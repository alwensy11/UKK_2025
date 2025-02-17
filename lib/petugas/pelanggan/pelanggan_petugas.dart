import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir_pl1/petugas/pelanggan/insert_pelanggan_petugas.dart';
import 'package:kasir_pl1/petugas/pelanggan/edit_pelanggan_petugas.dart';

class PelangganPetugas extends StatefulWidget {
  const PelangganPetugas({super.key});

  @override
  State<PelangganPetugas> createState() => _PelangganPetugasState();
}

class _PelangganPetugasState extends State<PelangganPetugas> {
  List<Map<String, dynamic>> pelanggans = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggans();
  }

  Future<void> fetchPelanggans() async {
    final response = await Supabase.instance.client.from('pelanggan').select();

    setState(() {
      pelanggans = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _deletePelanggans(int id) async {
    try {
      await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('PelangganID', id);
      fetchPelanggans();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pelanggan tidak ditemukan : $e'),
          backgroundColor: Colors.pinkAccent.shade100));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: pelanggans.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pelanggans.length,
              itemBuilder: (context, index) {
                final pelanggan = pelanggans[index];
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
                      pelanggan['NamaPelanggan'],
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      children: [
                        Text('Alamat : ${pelanggan['Alamat']}',
                            style: GoogleFonts.roboto(fontSize: 14)),
                        Text('No Telp : ${pelanggan['NomorTelepon']}',
                            style: GoogleFonts.roboto(fontSize: 14)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditPelangganPetugas(
                                            NamaPelanggan:
                                                pelanggan['NamaPelanggan'],
                                            Alamat: pelanggan['Alamat'],
                                            NomorTelepon:
                                                pelanggan['NomorTelepon'],
                                          )));

                              if (result != null) {
                                setState(() {
                                  pelanggans[index] = {
                                    'NamaPelanggan': result['NamaPelanggan'],
                                    'Alamat': result['Alamat'],
                                    'NomorTelepon': result['NomorTelepon']
                                  };
                                });
                              }
                            },
                            icon: Icon(Icons.edit),
                            color: Colors.blue),
                        IconButton(
                            onPressed: () {
                              _deletePelanggans(pelanggan['PelangganID']);
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red)
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
                    builder: (context) => InsertPelangganPetugas()));
            if (result == true) {
              fetchPelanggans();
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
