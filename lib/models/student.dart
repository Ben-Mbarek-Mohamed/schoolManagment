import 'package:hive/hive.dart';
import 'package:madrasti/models/ammount.dart';

part 'student.g.dart';

@HiveType(typeId: 1)
class Student extends HiveObject {
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
  List<Ammount>? requiredAmmount;
  @HiveField(6)
  List<Ammount>? payedAmmount;
  @HiveField(7)
  List<int>? absences;
  @HiveField(8)
  List<int>? groups;
  @HiveField(9)
  DateTime? birthDate;
  @HiveField(10)
  String? image;
  @HiveField(11)
  String? level;
  @HiveField(12)
  String? phone;
  @HiveField(13)
  String? address;

  Student({
      this.id,
      this.firstName,
      this.lastName,
      this.registrationNumber,
      this.registrationDate,
      this.requiredAmmount,
      this.payedAmmount,
      this.absences,
      this.groups,
      this.birthDate,
      this.image,
    this.level,
    this.phone,
    this.address
  });
}
