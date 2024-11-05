import 'package:hive/hive.dart';
part 'notification.g.dart';
@HiveType(typeId: 25)
class NotificationModel extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  bool? isStudent;
  @HiveField(2)
  DateTime? date;
  @HiveField(3)
  String? name;
  @HiveField(4)
  double? ammount;

  NotificationModel({this.id, this.isStudent, this.date, this.name, this.ammount});
}
