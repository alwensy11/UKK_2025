import 'package:flutter/material.dart';
import 'package:kasir_pl1/petugas/pelanggan/pelanggan_petugas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertPelangganPetugas extends StatefulWidget {
  const InsertPelangganPetugas({super.key});

  @override
  State<InsertPelangganPetugas> createState() => _InsertPelangganPetugasState();
}

class _InsertPelangganPetugasState extends State<InsertPelangganPetugas> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController NamaPelangganController = TextEditingController();
  final TextEditingController AlamatController = TextEditingController();
  final TextEditingController NomorTeleponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> InsertPelanggan() async {
      if (_formKey.currentState?.validate() ?? false) {
        String NamaPelanggan = NamaPelangganController.text;
        String Alamat = AlamatController.text;
        String NomorTelepon = NomorTeleponController.text;

        if (NamaPelanggan.isNotEmpty &&
            Alamat.isNotEmpty &&
            NomorTelepon.isNotEmpty) {
          final response = await Supabase.instance.client
              .from('pelanggan')
              .insert({
            'NamaPelanggan': NamaPelanggan,
            'Alamat': Alamat,
            'NomorTelepon': NomorTelepon
          });

          if (response == null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PelangganPetugas()));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Pelanggan berhasil ditambahkan'),
              backgroundColor: Colors.pinkAccent.shade100,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Error: ${response.error!.message}'),
                backgroundColor: Colors.pinkAccent.shade100));
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.white,
        title: Text('Tambah Pelanggan'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 75.0, left: 30.0, right: 30.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: NamaPelangganController,
                  decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Pelanggan wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: AlamatController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: NomorTeleponController,
                  decoration: InputDecoration(labelText: 'Nomor Telepon'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor Telepon wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.shade100),
                  onPressed: () {
                    InsertPelanggan();
                  },
                  child: Text(
                    'Tambah',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
