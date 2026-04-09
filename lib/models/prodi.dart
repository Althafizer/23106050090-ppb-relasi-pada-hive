import 'package:hive/hive.dart';

part 'prodi.g.dart';

@HiveType(typeId: 1)
class Prodi extends HiveObject {
  @HiveField(0)
  final String namaProdi;

  Prodi({required this.namaProdi});
}
