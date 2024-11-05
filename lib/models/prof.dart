import 'package:hive/hive.dart';
import 'package:madrasti/models/ammount.dart';
part 'prof.g.dart';
@HiveType(typeId: 2)
class Prof extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? firstName;
  @HiveField(2)
  String? lastName;
  @HiveField(3)
  String? registrationNumber;
  @HiveField(4)
  DateTime? registrationDate;
  @HiveField(5)
  List<int>? absences;
  @HiveField(6)
  List<Ammount>? dueAmmount;
  @HiveField(7)
  List<Ammount>? payedAmmount;
  @HiveField(8)
  String? major;
  @HiveField(9)
  List<int>? groups;
  @HiveField(10)
  DateTime? birthDate;
  @HiveField(11)
  String? image;

  Prof({
      this.id,
      this.firstName,
      this.lastName,
      this.registrationNumber,
      this.registrationDate,
      this.absences,
      this.dueAmmount,
      this.payedAmmount,
      this.major,
      this.groups,
      this.birthDate,
    this.image
  });
}