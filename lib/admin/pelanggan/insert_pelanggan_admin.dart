import 'package:flutter/material.dart';
import 'package:kasir_pl1/admin/pelanggan/pelanggan_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertPelangganAdmin extends StatefulWidget {
  const InsertPelangganAdmin({super.key});

  @override
  State<InsertPelangganAdmin> createState() => _InsertPelangganAdminState();
}

class _InsertPelangganAdminState extends State<InsertPelangganAdmin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController NamaPelangganController = TextEditingController();
  final TextEditingController AlamatController = TextEditingController();
  final TextEditingController NomorTeleponController = TextEditingController();
  final TextEditingController MemberController = TextEditingController();

  Future<void> InsertPelanggan() async {
    if (_formKey.currentState?.validate() ?? false) {
      String NamaPelanggan = NamaPelangganController.text.trim();
      String Alamat = AlamatController.text.trim();
      String NomorTelepon = NomorTeleponController.text.trim();
      String Member = MemberController.text.trim();

      final response = await Supabase.instance.client
          .from('pelanggan')
          .select()
          .eq('NamaPelanggan', NamaPelanggan)
          .eq('Alamat', Alamat)
          .eq('NomorTelepon', NomorTelepon)
          .eq('Member', Member)
          .single();

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pelanggan sudah terdaftar'),
          backgroundColor: Colors.pinkAccent.shade100,
        ));
      } else {
        if (response.isNotEmpty) {
          await Supabase.instance.client.from('pelanggan').insert({
            'NamaPelanggan': NamaPelanggan,
            'Alamat': Alamat,
            'NomorTelepon': NomorTelepon,
            'Member': Member,
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PelangganAdmin()),
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Pelanggan berhasil ditambahkan'),
            backgroundColor: Colors.pinkAccent.shade100,
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor Telepon wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: MemberController,
                  decoration: InputDecoration(labelText: 'Member'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Member wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.shade100),
                  onPressed: InsertPelanggan,
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

extension on PostgrestMap {
  get error => null;
}
