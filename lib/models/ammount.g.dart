// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ammount.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AmmountAdapter extends TypeAdapter<Ammount> {
  @override
  final int typeId = 4;

  @override
  Ammount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ammount(
      groupId: fields[0] as int?,
      ammount: fields[1] as double?,
      date: fields[2] as DateTime?,
      name: fields[3] as String?,
      personId: fields[4] as int?,
      id: fields[5] as int?,
      isExpence: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Ammount obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.groupId)
      ..writeByte(1)
      ..write(obj.ammount)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.personId)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.isExpence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmmountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
