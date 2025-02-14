import 'package:flutter/material.dart';
import 'package:kasir_pl1/admin/produk/produk_admin.dart';
import 'package:kasir_pl1/admin/user/user_admin.dart';
import 'package:kasir_pl1/login.dart';

class HalamanBerandaAdmin extends StatefulWidget {
  const HalamanBerandaAdmin({super.key});

  @override
  State<HalamanBerandaAdmin> createState() => _HalamanBerandaAdminState();
}

class _HalamanBerandaAdminState extends State<HalamanBerandaAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          backgroundColor: Colors.pinkAccent.shade100,
          child: ListView(
            children: [
              DrawerHeader(
                  child: ClipRRect(
                child: Image.asset(
                  'assets/logo.png'
                ),
              )),
              ListTile(
                title: Text('User', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserAdmin()));
                },
              ),
              ListTile(
                title: Text('Produk', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProdukAdmin()));
                },
              ),
              ListTile(
                title: Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HalamanLogin()));
                },
              )
            ],
          )),
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.white,
      ),
      body: Center()
    );
  }
}
