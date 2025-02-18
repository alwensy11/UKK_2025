import 'package:flutter/material.dart';
import 'package:kasir_pl1/petugas/penjualan/penjualan_petugas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

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

      setState(() {
        keranjang.add({
          'ProdukID': pilihProduk!['ProdukID'],
          'NamaProduk': pilihProduk!['NamaProduk'],
          'JumlahProduk': quantity,
          'Subtotal': itemSubtotal,
        });
        totalHarga += itemSubtotal;
        pilihProduk!['Stok'] -= quantity;
      });
    }
    }
  }

  Future<void> SubmitPenjualan() async {
    try {
      final penjualanResponse = await Supabase.instance.client
          .from('penjualan')
          .insert({
            'TanggalPenjualan': DateFormat('yyy-MM-dd').format(currentDate),
            'TotalHarga': totalHarga,
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
          content: Text('Transaksi berhasil disimpan'), // Pesan kesalahan
          backgroundColor: Colors.pinkAccent.shade100,
        ),
      );
      setState(() {
        keranjang.clear();
        totalHarga = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'), // Pesan kesalahan
          backgroundColor: Colors.pinkAccent.shade100,
        ),
      );
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => PenjualanPetugas()), // Arahkan ke MyHomePage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white, // Set warna ikon dan judul menjadi putih
        title: Text(
          'Transaksi Penjualan',
          style: TextStyle(color: Colors.white),
        ), // Judul aplikasi
        backgroundColor:
            Colors.pinkAccent.shade100, // Warna latar belakang AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Menambahkan padding di sekitar konten body
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Menyusun widget ke kiri
            children: [
              // Dropdown untuk memilih pelanggan
              DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText:
                        'Pilih Pelanggan'), // Label untuk dropdown pelanggan
                items: pelanggan.map((customer) {
                  return DropdownMenuItem(
                    value: customer,
                    child: Text(customer[
                        'NamaPelanggan']), // Menampilkan nama pelanggan di dropdown
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    pilihPelanggan = value as Map<String,
                        dynamic>; // Menyimpan pelanggan yang dipilih
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Pelanggan wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Menambahkan jarak antar widget
              // Dropdown untuk memilih produk
              DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText: 'Pilih Produk'), // Label untuk dropdown produk
                items: produk.map((product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text(product[
                        'NamaProduk']), // Menampilkan nama produk di dropdown
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    pilihProduk = value
                        as Map<String, dynamic>; // Menyimpan produk yang dipilih
                    subtotal = pilihProduk!['Harga'] *
                        (quantityController.text.isEmpty
                            ? 0
                            : int.parse(
                                quantityController.text)); // Menghitung subtotal
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
              // Input untuk jumlah produk
              TextFormField(
                controller:
                    quantityController, // Menghubungkan dengan kontroler jumlah
                decoration: InputDecoration(
                    labelText: 'Jumlah Produk'), // Label untuk input jumlah
                keyboardType: TextInputType.number, // Tipe input untuk angka
                onChanged: (value) {
                  setState(() {
                    subtotal = pilihProduk != null
                        ? pilihProduk!['Harga'] *
                            int.parse(
                                value) // Memperbarui subtotal ketika jumlah berubah
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
              // Tombol untuk menambahkan produk ke keranjang
              ElevatedButton(
                onPressed:
                    tambahKeKeranjang, // Memanggil fungsi addTokeranjang saat tombol ditekan
                child: Text('Tambahkan ke Keranjang',
                    style: TextStyle(color: Colors.pinkAccent)), // Teks tombol
              ),
              Divider(), // Pembatas antar bagian
              Expanded(
                // List view untuk menampilkan item di keranjang
                child: ListView.builder(
                  itemCount: keranjang.length, // Jumlah item dalam keranjang
                  itemBuilder: (context, index) {
                    final item =
                        keranjang[index]; // Mengambil item keranjang saat ini
                    return ListTile(
                      title: Text(item['NamaProduk']), // Menampilkan nama produk
                      subtitle: Text(
                          'Jumlah: ${item['JumlahProduk']} - Subtotal: Rp ${item['Subtotal']}'), // Menampilkan jumlah dan subtotal produk
                    );
                  },
                ),
              ),
              Divider(), // Pembatas antara keranjang dan total harga
              Text('Total Harga: Rp $totalHarga',
                  style: TextStyle(
                      fontWeight: FontWeight.bold)), // Menampilkan total harga
              SizedBox(height: 16.0),
              // Tombol untuk menyimpan transaksi
              ElevatedButton(
                onPressed:
                    SubmitPenjualan, // Memanggil fungsi submitSale saat tombol ditekan
                child: Text(
                  'Simpan Transaksi',
                  style: TextStyle(color: Colors.pinkAccent),
                ), // Teks tombol
              ),
            ],
          ),
        ),
      ),
    );
  }
}
