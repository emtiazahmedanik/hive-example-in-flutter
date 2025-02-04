// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contactModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class contactModelAdapter extends TypeAdapter<contactModel> {
  @override
  final int typeId = 0;

  @override
  contactModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return contactModel(
      title: fields[0] as String?,
      imageBytes: fields[1] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, contactModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.imageBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is contactModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
