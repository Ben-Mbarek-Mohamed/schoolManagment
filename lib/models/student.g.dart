// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 1;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      id: fields[0] as int?,
      firstName: fields[1] as String?,
      lastName: fields[2] as String?,
      registrationNumber: fields[3] as String?,
      registrationDate: fields[4] as DateTime?,
      requiredAmmount: (fields[5] as List?)?.cast<Ammount>(),
      payedAmmount: (fields[6] as List?)?.cast<Ammount>(),
      absences: (fields[7] as List?)?.cast<int>(),
      groups: (fields[8] as List?)?.cast<int>(),
      birthDate: fields[9] as DateTime?,
      image: fields[10] as String?,
      level: fields[11] as String?,
    )
      ..phone = fields[12] as String?
      ..address = fields[13] as String?;
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.requiredAmmount)
      ..writeByte(6)
      ..write(obj.payedAmmount)
      ..writeByte(7)
      ..write(obj.absences)
      ..writeByte(8)
      ..write(obj.groups)
      ..writeByte(9)
      ..write(obj.birthDate)
      ..writeByte(10)
      ..write(obj.image)
      ..writeByte(11)
      ..write(obj.level)
      ..writeByte(12)
      ..write(obj.phone)
      ..writeByte(13)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
