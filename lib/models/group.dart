import 'package:hive/hive.dart';
import 'package:madrasti/models/sessionTime.dart';
part 'group.g.dart';

@HiveType(typeId: 0)
class Groupe extends HiveObject{

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  DateTime? startDate;
  @HiveField(3)
  DateTime? endDate;
  @HiveField(4)
  bool? isRegular;
  @HiveField(5)
  bool? isProfPaymentRegular;
  @HiveField(6)
  List<SessionTime>? sessionDays;
  @HiveField(7)
  List<String>? studentsId;
  @HiveField(8)
  List<String>? profsId;
  @HiveField(9)
  double? profPrice;
  @HiveField(10)
  double? studentPrice;
  @HiveField(11)
  double? profPoucentage;
  @HiveField(12)
  double? absenceAmmount;

  Groupe({
      this.id,
      this.name,
      this.startDate,
      this.endDate,
      this.isRegular,
      this.isProfPaymentRegular,
      this.sessionDays,
      this.studentsId,
      this.profsId,
      this.profPrice,
      this.studentPrice,
      this.profPoucentage,
      this.absenceAmmount});
}
