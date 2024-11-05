// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupeAdapter extends TypeAdapter<Groupe> {
  @override
  final int typeId = 0;

  @override
  Groupe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Groupe(
      id: fields[0] as int?,
      name: fields[1] as String?,
      startDate: fields[2] as DateTime?,
      endDate: fields[3] as DateTime?,
      isRegular: fields[4] as bool?,
      isProfPaymentRegular: fields[5] as bool?,
      sessionDays: (fields[6] as List?)?.cast<SessionTime>(),
      studentsId: (fields[7] as List?)?.cast<String>(),
      profsId: (fields[8] as List?)?.cast<String>(),
      profPrice: fields[9] as double?,
      studentPrice: fields[10] as double?,
      profPoucentage: fields[11] as double?,
      absenceAmmount: fields[12] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Groupe obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.isRegular)
      ..writeByte(5)
      ..write(obj.isProfPaymentRegular)
      ..writeByte(6)
      ..write(obj.sessionDays)
      ..writeByte(7)
      ..write(obj.studentsId)
      ..writeByte(8)
      ..write(obj.profsId)
      ..writeByte(9)
      ..write(obj.profPrice)
      ..writeByte(10)
      ..write(obj.studentPrice)
      ..writeByte(11)
      ..write(obj.profPoucentage)
      ..writeByte(12)
      ..write(obj.absenceAmmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
