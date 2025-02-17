import 'package:flutter/material.dart';
import 'package:kasir_pl1/petugas/beranda_petugas.dart';
import 'package:kasir_pl1/login.dart';

class AwalBerandaPetugas extends StatefulWidget {
  const AwalBerandaPetugas({super.key});

  @override
  State<AwalBerandaPetugas> createState() => _AwalBerandaPetugasState();
}

class _AwalBerandaPetugasState extends State<AwalBerandaPetugas> {
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
                          builder: (context) => AwalBerandaPetugas()));
                },
              ),
              ListTile(
                title: Text('Dashboard',
                    style: TextStyle(color: Colors.pinkAccent.shade100)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HalamanBerandaPetugas()));
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
        body: Container());
  }
}
