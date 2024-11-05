import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'lesson.dart';

part 'schedule.g.dart';
@HiveType(typeId: 21)
class Schedule extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  List<Lesson>? lessons ;
  @HiveField(3)
  DateTime? date;

  Schedule({this.id, this.name, this.lessons, this.date});
}