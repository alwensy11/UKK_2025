import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kasir_pl1/petugas/penjualan/penjualan_petugas.dart';

class InsertPenjualanPetugas extends StatefulWidget {
  const InsertPenjualanPetugas({super.key});

  @override
  State<InsertPenjualanPetugas> createState() => _InsertPenjualanPetugasState();
}

class _InsertPenjualanPetugasState extends State<InsertPenjualanPetugas> {
  final _formKey = GlobalKey<FormState>();

  DateTime currentDate = DateTime.now();

  List<Map<String, dynamic>> pelanggan = [];
  List<Map<String, dynamic>> produk = [];
  Map<String, dynamic>? pilihPelanggan;
  Map<String, dynamic>? pilihProduk;

  TextEditingController quantityController = TextEditingController();
  double subtotal = 0;
  double totalHargaAsli = 0;
  double totalHarga = 0;
  List<Map<String, dynamic>> keranjang = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
    fetchProduk();
  }

  Future<void> fetchPelanggan() async {
    final response = await Supabase.instance.client.from('pelanggan').select();
    setState(() {
      pelanggan = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> fetchProduk() async {
    final response = await Supabase.instance.client.from('produk').select();
    setState(() {
      produk = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> tambahKeKeranjang() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (pilihProduk != null && quantityController.text.isNotEmpty) {
        int quantity = int.parse(quantityController.text);
        double price = pilihProduk!['Harga'];
        double itemSubtotal = price * quantity;

        if (pilihProduk!['Stok'] == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Stok sudah habis'),
              backgroundColor: Colors.pinkAccent.shade100,
            ),
          );
          return;
        }

        if (pilihProduk!['Stok'] < quantity) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Stok tidak cukup'),
              backgroundColor: Colors.pinkAccent.shade100,
            ),
          );
          return;
        }

        int existingIndex = keranjang.indexWhere(
          (item) => item['ProdukID'] == pilihProduk!['ProdukID'],
        );

        if (existingIndex != -1) {
          keranjang[existingIndex]['JumlahProduk'] += quantity;
          keranjang[existingIndex]['Subtotal'] += itemSubtotal;
        } else {
          keranjang.add({
            'ProdukID': pilihProduk!['ProdukID'],
            'NamaProduk': pilihProduk!['NamaProduk'],
            'JumlahProduk': quantity,
            'Subtotal': itemSubtotal,
          });
        }

        double tempTotalHargaAsli =
            keranjang.fold(0, (sum, item) => sum + item['Subtotal']);
        double tempTotalHarga = tempTotalHargaAsli;

        if (pilihPelanggan != null) {
          final memberType = pilihPelanggan!['Member'];

          if (memberType == 'Platinum') {
            tempTotalHarga *= 0.90; 
          } else if (memberType == 'Gold') {
            tempTotalHarga *= 0.95; 
          } else if (memberType == 'Silver') {
            tempTotalHarga *= 0.98; 
          }
        }

        setState(() {
          totalHargaAsli = tempTotalHargaAsli;
          totalHarga = tempTotalHarga;
        });

        pilihProduk!['Stok'] -= quantity;
      }
    }
  }

  Future<void> SubmitPenjualan() async {
    try {
      double finalTotalHarga = totalHarga;

      final penjualanResponse = await Supabase.instance.client
          .from('penjualan')
          .insert({
            'TanggalPenjualan': DateFormat('yyy-MM-dd').format(currentDate),
            'TotalHarga': finalTotalHarga, 
            'PelangganID': pilihPelanggan!['PelangganID']
          })
          .select()
          .single();

      final PenjualanID = penjualanResponse['PenjualanID'];

      for (var item in keranjang) {
        await Supabase.instance.client.from('detailpenjualan').insert({
          'PenjualanID': PenjualanID,
          'ProdukID': item['ProdukID'],
          'JumlahProduk': item['JumlahProduk'],
          'Subtotal': item['Subtotal']
        });

        await Supabase.instance.client.from('produk').update(
            {'Stok': pilihProduk!['Stok']}).eq('ProdukID', item['ProdukID']);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaksi berhasil disimpan'),
          backgroundColor: Colors.pinkAccent.shade100,
        ),
      );

      setState(() {
        keranjang.clear();
        totalHarga = 0;
        totalHargaAsli = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.pinkAccent.shade100,
        ),
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PenjualanPetugas()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Transaksi Penjualan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Pilih Pelanggan'),
                items: pelanggan.map((customer) {
                  return DropdownMenuItem(
                    value: customer,
                    child: Text(customer['NamaPelanggan']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    pilihPelanggan = value as Map<String, dynamic>;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Pelanggan wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Pilih Produk'),
                items: produk.map((product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text(product['NamaProduk']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    pilihProduk = value as Map<String, dynamic>;
                    subtotal = pilihProduk!['Harga'] *
                        (quantityController.text.isEmpty
                            ? 0
                            : int.parse(quantityController.text));
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Produk wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Jumlah Produk'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    subtotal = pilihProduk != null
                        ? pilihProduk!['Harga'] * int.parse(value)
                        : 0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah Produk wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: tambahKeKeranjang,
                child: Text('Tambahkan ke Keranjang',
                    style: TextStyle(color: Colors.pinkAccent)),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: keranjang.length,
                  itemBuilder: (context, index) {
                    final item = keranjang[index];
                    return ListTile(
                      title: Text(item['NamaProduk']),
                      subtitle: Text(
                          'Jumlah: ${item['JumlahProduk']} - Subtotal: Rp ${NumberFormat('#,###').format(item['Subtotal'])}'),
                    );
                  },
                ),
              ),
              Divider(),
              Text(
                'Total Harga Setelah Diskon: Rp ${NumberFormat('#,###').format(totalHarga)}',
                style:
                    TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: SubmitPenjualan,
                child: Text(
                  'Simpan Transaksi',
                  style: TextStyle(color: Colors.pinkAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
