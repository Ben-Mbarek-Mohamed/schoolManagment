
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'room.g.dart';
@HiveType(typeId: 5)
class Room extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  List<String>? groups;
  @HiveField(3)
  List<String>? days;
  @HiveField(4)
  TimeOfDay? stratTime;
  @HiveField(5)
  TimeOfDay? endTime;

  Room({
      this.id, this.name, this.groups, this.days, this.stratTime, this.endTime
  });
}