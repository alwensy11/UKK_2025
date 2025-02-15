import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir_pl1/admin/produk/insert_produk_admin.dart';
import 'package:kasir_pl1/admin/produk/edit_produk_admin.dart';

class ProdukAdmin extends StatefulWidget {
  const ProdukAdmin({super.key});

  @override
  State<ProdukAdmin> createState() => _ProdukAdminState();
}

class _ProdukAdminState extends State<ProdukAdmin> {
  List<Map<String, dynamic>> produks = [];

  @override
  void initState() {
    super.initState();
    fetchProduks();
  }

  Future<void> fetchProduks() async {
    final response = await Supabase.instance.client.from('produk').select();

    setState(() {
      produks = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _deleteProduks(int id) async {
    try {
      await Supabase.instance.client.from('produk').delete().eq('ProdukID', id);
      fetchProduks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Produk tidak ditemukan : $e'),
          backgroundColor: Colors.pinkAccent.shade100));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: produks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: produks.length,
              itemBuilder: (context, index) {
                final produk = produks[index];
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
                    title: Text(produk['NamaProduk']),
                    subtitle: Column(
                      children: [
                        Text('Harga : Rp. ${produk['Harga']}'),
                        Text('Stok : ${produk['Stok']}'),
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
                                        builder: (context) => EditProdukAdmin(
                                            namaProduk: produk['NamaProduk'],
                                            harga: produk['Harga'],
                                            stok: produk['Stok'],
                                            )));

                              if (result != null) {
                                setState(() {
                                  produks[index] = {
                                    'NamaProduk' : result['namaProduk'],
                                    'Harga' : result['harga'],
                                    'Stok' : result['stok'],
                                  };
                                });
                              }
                            },
                            icon: Icon(Icons.edit),
                            color: Colors.blue),
                        IconButton(
                            onPressed: () {
                              _deleteProduks(produk['ProdukID']);
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
                MaterialPageRoute(builder: (context) => InsertProdukAdmin()));
            if (result == true) {
              fetchProduks();
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
