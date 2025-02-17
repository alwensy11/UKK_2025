import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_pl1/admin/beranda_admin.dart';
import 'package:kasir_pl1/login.dart';

class AwalBerandaAdmin extends StatefulWidget {
  const AwalBerandaAdmin({super.key});

  @override
  State<AwalBerandaAdmin> createState() => _AwalBerandaAdminState();
}

class _AwalBerandaAdminState extends State<AwalBerandaAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              DrawerHeader(
                child: ClipRRect(
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              ListTile(
                title: Text('Beranda',
                    style: TextStyle(color: Colors.pinkAccent.shade100)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AwalBerandaAdmin()));
                },
              ),
              ListTile(
                title: Text('Dashboard',
                    style: TextStyle(color: Colors.pinkAccent.shade100)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HalamanBerandaAdmin()));
                },
              ),
              ListTile(
                title: Text('Logout',
                    style: TextStyle(color: Colors.pinkAccent.shade100)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HalamanLogin()));
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
            backgroundColor: Colors.pinkAccent.shade100,
            foregroundColor: Colors.white),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  child: Image.asset('assets/logo.png', fit: BoxFit.cover, height: 300.0, width: 300.0,),
                ),
                Text('Selamat Datang', style: GoogleFonts.lilitaOne(color: Colors.pinkAccent.shade100, fontWeight: FontWeight.bold, fontSize: 40),),
                Text(' Di Aplikasi Kasir Toko Donat', style: GoogleFonts.lilitaOne(color: Colors.pinkAccent.shade100, fontWeight: FontWeight.bold, fontSize: 25),)
              ],
            ),
          ),
        ));
  }
}
