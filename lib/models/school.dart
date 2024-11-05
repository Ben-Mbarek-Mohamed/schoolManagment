import 'package:hive/hive.dart';
part 'school.g.dart';
@HiveType(typeId: 22)
class School extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? phone;
  @HiveField(4)
  String? address;
  @HiveField(5)
  String? webSite;
  @HiveField(6)
  String? image;

  School(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.webSite,
      this.image});
}
