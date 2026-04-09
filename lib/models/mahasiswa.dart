import 'package:hive/hive.dart';

part 'mahasiswa.g.dart';

@HiveType(typeId: 0)
class Mahasiswa extends HiveObject {
  @HiveField(0)
  final String nama;

  @HiveField(1)
  final String nim;

  @HiveField(2)
  final int prodiId;

  Mahasiswa({
    required this.nama,
    required this.nim,
    required this.prodiId,
  });
}
