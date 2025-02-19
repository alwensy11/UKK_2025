import 'package:flutter/material.dart';
import 'package:kasir_pl1/admin/pelanggan/pelanggan_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPelangganAdmin extends StatefulWidget {
  final String NamaPelanggan;
  final String Alamat;
  final String NomorTelepon;
  final String Member;

  const EditPelangganAdmin({
    Key? key,
    required this.NamaPelanggan,
    required this.Alamat,
    required this.NomorTelepon,
    required this.Member,
  }) : super(key: key);

  @override
  State<EditPelangganAdmin> createState() => _EditPelangganAdminState();
}

class _EditPelangganAdminState extends State<EditPelangganAdmin> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController NamaPelangganController;
  late TextEditingController AlamatController;
  late TextEditingController NomorTeleponController;
  late TextEditingController MemberController;

  @override
  void initState() {
    super.initState();
    NamaPelangganController = TextEditingController(text: widget.NamaPelanggan);
    AlamatController = TextEditingController(text: widget.Alamat);
    NomorTeleponController = TextEditingController(text: widget.NomorTelepon);
    MemberController = TextEditingController(text: widget.Member);
  }

  @override
  void dispose() {
    super.dispose();
    NamaPelangganController.dispose();
    AlamatController.dispose();
    NomorTeleponController.dispose();
    MemberController.dispose();
  }

  Future<void> EditPelanggan() async {
    final response = await Supabase.instance.client
        .from('pelanggan')
        .update({
          'NamaPelanggan': NamaPelangganController.text,
          'Alamat': AlamatController.text,
          'NomorTelepon': NomorTeleponController.text,
          'Member': MemberController.text,
        })
        .eq('NamaPelanggan', widget.NamaPelanggan)
        .select();

    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal memperbarui pelanggan'),
        backgroundColor: Colors.pinkAccent.shade100,
      ));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PelangganAdmin()),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pelanggan berhasil diperbarui'),
        backgroundColor: Colors.pinkAccent.shade100,
      ));
    }
  }

  Future<void> simpanPelanggan() async {
    if (_formKey.currentState!.validate()) {
      await EditPelanggan();

      Navigator.pop(context, {
        'NamaPelanggan': NamaPelangganController.text,
        'Alamat': AlamatController.text,
        'NomorTelepon': NomorTeleponController.text,
        'Member': MemberController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.white,
        title: Text('Edit Pelanggan'),
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
                  onPressed: () {
                    simpanPelanggan();
                  },
                  child: Text(
                    'Simpan',
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

extension on PostgrestList {
  get error => null;
}
