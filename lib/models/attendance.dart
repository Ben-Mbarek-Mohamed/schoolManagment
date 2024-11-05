import 'package:hive/hive.dart';

part 'attendance.g.dart';

@HiveType(typeId: 7)
class Attendance extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? groupId;
  @HiveField(2)
  DateTime? date;
  @HiveField(3)
  List<int>? presentStudent;
  @HiveField(4)
  List<int>? absentStudent;
  @HiveField(5)
  bool? isProfPresent;
  @HiveField(6)
  List<int>? presentProf;
  @HiveField(7)
  List<int>? absentProf;

  Attendance({
      this.id,
      this.groupId,
      this.date,
      this.presentStudent,
      this.absentStudent,
      this.isProfPresent,
      this.presentProf,
      this.absentProf});
}
