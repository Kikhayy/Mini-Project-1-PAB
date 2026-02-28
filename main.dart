import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Resep {
  String nama;
  String bahan;
  String cara;

  Resep({required this.nama, required this.bahan, required this.cara});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Resep> daftarResep = [];

  void tambahResep(Resep resep) {
    setState(() {
      daftarResep.add(resep);
    });
  }

  void updateResep(int index, Resep resepBaru) {
    setState(() {
      daftarResep[index] = resepBaru;
    });
  }

  void hapusResep(int index) {
    setState(() {
      daftarResep.removeAt(index);
    });
  }

  void bukaForm({Resep? resep, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPage(
          resep: resep,
          index: index,
          onSave: (Resep resepBaru) {
            if (index != null) {
              updateResep(index, resepBaru);
            } else {
              tambahResep(resepBaru);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplikasi Data Resep Masakan"),
        centerTitle: true,
      ),
      body: daftarResep.isEmpty
          ? Center(child: Text("Belum ada resep"))
          : ListView.builder(
              itemCount: daftarResep.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(daftarResep[index].nama),
                    subtitle: Text(daftarResep[index].bahan),
                    onTap: () =>
                        bukaForm(resep: daftarResep[index], index: index),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => hapusResep(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => bukaForm(),
      ),
    );
  }
}

class FormPage extends StatefulWidget {
  final Resep? resep;
  final int? index;
  final Function(Resep) onSave;

  FormPage({this.resep, this.index, required this.onSave});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _namaController = TextEditingController();
  final _bahanController = TextEditingController();
  final _caraController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.resep != null) {
      _namaController.text = widget.resep!.nama;
      _bahanController.text = widget.resep!.bahan;
      _caraController.text = widget.resep!.cara;
    }
  }

  void simpanData() {
    if (_namaController.text.isEmpty ||
        _bahanController.text.isEmpty ||
        _caraController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Semua field harus diisi")));
      return;
    }

    Resep resepBaru = Resep(
      nama: _namaController.text,
      bahan: _bahanController.text,
      cara: _caraController.text,
    );

    widget.onSave(resepBaru);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resep == null ? "Tambah Resep" : "Edit Resep"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: "Nama Resep",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _bahanController,
                decoration: InputDecoration(
                  labelText: "Bahan",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _caraController,
                decoration: InputDecoration(
                  labelText: "Cara Memasak",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: simpanData,
                child: Text("Simpan"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
