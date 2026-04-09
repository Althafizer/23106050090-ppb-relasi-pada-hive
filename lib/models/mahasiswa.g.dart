// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mahasiswa.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MahasiswaAdapter extends TypeAdapter<Mahasiswa> {
  @override
  final int typeId = 0;

  @override
  Mahasiswa read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mahasiswa(
      nama: fields[0] as String,
      nim: fields[1] as String,
      prodiId: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Mahasiswa obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.nim)
      ..writeByte(2)
      ..write(obj.prodiId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MahasiswaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
