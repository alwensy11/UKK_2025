import 'package:flutter/material.dart';
import 'package:kasir_pl1/petugas/produk/produk_petugas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertProdukPetugas extends StatefulWidget {
  const InsertProdukPetugas({super.key});

  @override
  State<InsertProdukPetugas> createState() => _InsertProdukPetugasState();
}

class _InsertProdukPetugasState extends State<InsertProdukPetugas> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaProdukController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController stokController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> InsertProduct() async {
      if (_formKey.currentState?.validate() ?? false) {
        String namaProduk = namaProdukController.text;
        String harga = hargaController.text;
        String stok = stokController.text;

        if (namaProduk.isNotEmpty && harga.isNotEmpty && stok.isNotEmpty) {
          final response = await Supabase.instance.client
              .from('produk')
              .insert({'NamaProduk': namaProduk, 'Harga': harga, 'Stok': stok});

          if (response == null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProdukPetugas()));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Produk berhasil ditambahkan'),
              backgroundColor: Colors.pinkAccent.shade100,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${response.error!.message}')));
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.white,
        title: Text('Tambah Produk'),
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
                  decoration: InputDecoration(labelText: 'Nama Produk'),
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
                    InsertProduct();
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
