// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessionTime.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionTimeAdapter extends TypeAdapter<SessionTime> {
  @override
  final int typeId = 3;

  @override
  SessionTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionTime(
      day: fields[0] as String?,
      startTime: fields[1] as TimeOfDay?,
      endTime: fields[2] as TimeOfDay?,
    );
  }

  @override
  void write(BinaryWriter writer, SessionTime obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
