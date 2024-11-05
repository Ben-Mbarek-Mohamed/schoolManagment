import 'package:hive/hive.dart';
part 'user.g.dart';
@HiveType(typeId: 30)
class User extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  bool? isAdmin;
  @HiveField(2)
  String? userName;
  @HiveField(3)
  String? password;
  @HiveField(4)
  List<String>? permissions;

  User({this.id, this.isAdmin, this.userName, this.password, this.permissions});
}