// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceAdapter extends TypeAdapter<Attendance> {
  @override
  final int typeId = 7;

  @override
  Attendance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attendance(
      id: fields[0] as int?,
      groupId: fields[1] as int?,
      date: fields[2] as DateTime?,
      presentStudent: (fields[3] as List?)?.cast<int>(),
      absentStudent: (fields[4] as List?)?.cast<int>(),
      isProfPresent: fields[5] as bool?,
      presentProf: (fields[6] as List?)?.cast<int>(),
      absentProf: (fields[7] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Attendance obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.presentStudent)
      ..writeByte(4)
      ..write(obj.absentStudent)
      ..writeByte(5)
      ..write(obj.isProfPresent)
      ..writeByte(6)
      ..write(obj.presentProf)
      ..writeByte(7)
      ..write(obj.absentProf);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
