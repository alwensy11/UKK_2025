import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir_pl1/admin/pelanggan/insert_pelanggan_admin.dart';
import 'package:kasir_pl1/admin/pelanggan/edit_pelanggan_admin.dart';

class PelangganAdmin extends StatefulWidget {
  const PelangganAdmin({super.key});

  @override
  State<PelangganAdmin> createState() => _PelangganAdminState();
}

class _PelangganAdminState extends State<PelangganAdmin> {
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
      await Supabase.instance.client.from('pelanggan').delete().eq('PelangganID', id);
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
                      pelanggan['NamaPelanggan'] ?? 'Tidak ada Nama Pelanggan',
                      style:
                          GoogleFonts.happyMonkey(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      children: [
                        Text(pelanggan['Alamat'] ?? 'Tidak ada Alamat'),
                        Text(pelanggan['NomorTelepon'] ?? 'Tidak ada Nomor Telepon'),
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
                                      builder: (context) => EditPelangganAdmin(
                                            NamaPelanggan: pelanggan['NamaPelanggan'],
                                            Alamat: pelanggan['Alamat'],
                                            NomorTelepon: pelanggan['NomorTelepon'],
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
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => InsertPelangganAdmin()));
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
