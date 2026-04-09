import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/mahasiswa.dart';
import 'models/prodi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Jika sebelumnya sudah pernah membuat box dengan struktur/model berbeda,
  // hapus agar tidak konflik saat menjalankan contoh ini.
  await Hive.deleteBoxFromDisk('mahasiswaBox');

  Hive.registerAdapter(MahasiswaAdapter());
  Hive.registerAdapter(ProdiAdapter());

  await Hive.openBox<Mahasiswa>('mahasiswaBox');
  await Hive.openBox<Prodi>('prodiBox');

  final prodiBox = Hive.box<Prodi>('prodiBox');
  if (prodiBox.isEmpty) {
    prodiBox.addAll([
      Prodi(namaProdi: 'Informatika'),
      Prodi(namaProdi: 'Biologi'),
      Prodi(namaProdi: 'Fisika'),
    ]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relasi pada Hive',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const MahasiswaPage(),
    );
  }
}

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({super.key});

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();

  final Box<Mahasiswa> box = Hive.box<Mahasiswa>('mahasiswaBox');
  final Box<Prodi> prodiBox = Hive.box<Prodi>('prodiBox');

  int? selectedProdiId;
  int? editIndex;

  @override
  void dispose() {
    namaController.dispose();
    nimController.dispose();
    super.dispose();
  }

  void saveData() {
    final prodiId = selectedProdiId;
    if (prodiId == null) return;

    final mahasiswa = Mahasiswa(
      nama: namaController.text,
      nim: nimController.text,
      prodiId: prodiId,
    );

    if (editIndex == null) {
      box.add(mahasiswa);
    } else {
      box.putAt(editIndex!, mahasiswa);
      editIndex = null;
    }

    clearForm();
  }

  void editData(int index) {
    final data = box.getAt(index);
    if (data == null) return;

    namaController.text = data.nama;
    nimController.text = data.nim;

    setState(() {
      selectedProdiId = data.prodiId;
      editIndex = index;
    });
  }

  void clearForm() {
    namaController.clear();
    nimController.clear();

    setState(() {
      selectedProdiId = null;
      editIndex = null;
    });
  }

  Prodi? _getProdiByIndex(int prodiId) {
    if (prodiId < 0 || prodiId >= prodiBox.length) return null;
    return prodiBox.getAt(prodiId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relasi pada Hive'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nimController,
              decoration: const InputDecoration(labelText: 'NIM'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              key: ValueKey(selectedProdiId),
              initialValue: selectedProdiId,
              hint: const Text('Pilih Prodi'),
              items: List.generate(prodiBox.length, (index) {
                final prodi = prodiBox.getAt(index);
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(prodi?.namaProdi ?? '-'),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedProdiId = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: saveData,
                    child: Text(editIndex == null ? 'Simpan' : 'Update'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: clearForm,
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, Box<Mahasiswa> box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text('Belum ada data mahasiswa'));
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final data = box.getAt(index);
                      if (data == null) return const SizedBox.shrink();

                      final prodi = _getProdiByIndex(data.prodiId);

                      return Card(
                        child: ListTile(
                          title: Text(data.nama),
                          subtitle: Text(
                            'NIM: ${data.nim} | ${prodi?.namaProdi ?? '-'}',
                          ),
                          onTap: () => editData(index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
