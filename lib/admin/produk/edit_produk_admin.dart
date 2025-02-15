import 'package:flutter/material.dart';
import 'package:kasir_pl1/admin/produk/produk_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProdukAdmin extends StatefulWidget {
  final String namaProduk;
  final String harga;
  final String stok;

  const EditProdukAdmin({
    Key? key,
    required this.namaProduk,
    required this.harga,
    required this.stok,
  }) : super(key: key);

  @override
  State<EditProdukAdmin> createState() => _EditProdukAdminState();
}

class _EditProdukAdminState extends State<EditProdukAdmin> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaProdukController;
  late TextEditingController hargaController;
  late TextEditingController stokController;

  @override
  void initState() {
    super.initState();
    namaProdukController = TextEditingController(text: widget.namaProduk);
    hargaController = TextEditingController(text: widget.harga);
    stokController = TextEditingController(text: widget.stok);
  }

  @override
  void dispose() {
    super.initState();
    namaProdukController.dispose();
    hargaController.dispose();
    stokController.dispose();
    super.dispose();
  }

  Future<void> EditUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await Supabase.instance.client
          .from('produk')
          .update({
            'NamaProduk': namaProdukController.text,
            'Harga': hargaController.text,
            'Stok': stokController.text
          })
          .eq('NamaProduk', widget.namaProduk)
          .select();

      if (response == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProdukAdmin()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Produk berhasil diperbarui'),
            backgroundColor: Colors.pinkAccent.shade100));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Gagal memperbarui produk'),
            backgroundColor: Colors.pinkAccent.shade100));
      }
    }
  }

    Future<void> simpanUser() async {
      if (_formKey.currentState!.validate()) {
        await EditUser();

        Navigator.pop(context, {
          'NamaProduk': namaProdukController.text,
          'Harga': hargaController.text,
          'Stok': stokController.text,
        });
      }
    }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.white,
        title: Text('Edit Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 75.0, left: 30.0, right: 30.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: namaProdukController,
                  decoration: InputDecoration(labelText: 'namaProduk'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Produk wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: hargaController,
                  decoration: InputDecoration(labelText: 'Harga'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga wajib diisi';
                    } else {
                      if (double.tryParse(value) == null) {
                        return 'Harga harus diisi dengan angka';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: stokController,
                  decoration: InputDecoration(labelText: 'Stok'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stok wajib diisi';
                    } else {
                      if (double.tryParse(value) == null) {
                        return 'Harga harus diisi dengan angka';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.shade100),
                  onPressed: () {
                    simpanUser();
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
