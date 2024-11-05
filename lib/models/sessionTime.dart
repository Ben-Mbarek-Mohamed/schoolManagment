import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'sessionTime.g.dart';
@HiveType(typeId: 3)
class SessionTime extends HiveObject{
  @HiveField(0)
  String? day;
  @HiveField(1)
  TimeOfDay? startTime;
  @HiveField(2)
  TimeOfDay? endTime;

  SessionTime({this.day, this.startTime, this.endTime});
}