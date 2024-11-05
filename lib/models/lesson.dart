import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'lesson.g.dart';
@HiveType(typeId: 20)
class Lesson extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  Color color;
  @HiveField(2)
  TimeOfDay startTime;
  @HiveField(3)
  TimeOfDay endTime;
  @HiveField(4)
  String day;

  Lesson({
    required this.name,
    required this.color,
    required this.startTime,
    required this.endTime,
    required this.day,
  });
}