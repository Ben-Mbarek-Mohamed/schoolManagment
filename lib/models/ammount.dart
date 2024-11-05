import 'package:hive/hive.dart';

part 'ammount.g.dart';

@HiveType(typeId: 4)
class Ammount extends HiveObject {
  @HiveField(0)
  int? groupId;
  @HiveField(1)
  double? ammount;
  @HiveField(2)
  DateTime? date;
  @HiveField(3)
  String? name;
  @HiveField(4)
  int? personId;
  @HiveField(5)
  int? id;
  @HiveField(6)
  bool? isExpence;

  Ammount({this.groupId, this.ammount, this.date, this.name, this.personId,
      this.id, this.isExpence});
}
