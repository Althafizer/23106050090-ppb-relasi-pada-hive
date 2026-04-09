// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prodi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProdiAdapter extends TypeAdapter<Prodi> {
  @override
  final int typeId = 1;

  @override
  Prodi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prodi(
      namaProdi: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Prodi obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.namaProdi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProdiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
