// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prof.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfAdapter extends TypeAdapter<Prof> {
  @override
  final int typeId = 2;

  @override
  Prof read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prof(
      id: fields[0] as int?,
      firstName: fields[1] as String?,
      lastName: fields[2] as String?,
      registrationNumber: fields[3] as String?,
      registrationDate: fields[4] as DateTime?,
      absences: (fields[5] as List?)?.cast<int>(),
      dueAmmount: (fields[6] as List?)?.cast<Ammount>(),
      payedAmmount: (fields[7] as List?)?.cast<Ammount>(),
      major: fields[8] as String?,
      groups: (fields[9] as List?)?.cast<int>(),
      birthDate: fields[10] as DateTime?,
      image: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Prof obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.registrationNumber)
      ..writeByte(4)
      ..write(obj.registrationDate)
      ..writeByte(5)
      ..write(obj.absences)
      ..writeByte(6)
      ..write(obj.dueAmmount)
      ..writeByte(7)
      ..write(obj.payedAmmount)
      ..writeByte(8)
      ..write(obj.major)
      ..writeByte(9)
      ..write(obj.groups)
      ..writeByte(10)
      ..write(obj.birthDate)
      ..writeByte(11)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
