import 'package:hive/hive.dart';
import 'package:madrasti/models/attendance.dart';

class AttendanceService{
  Box<Attendance> box = Hive.box<Attendance>('attendances');

  List<Attendance> getAll(){
    return box.values.toList().cast<Attendance>();
  }

  Future<void> add(Attendance attendance) async {
    int id = await box.add(attendance);
    attendance.id = id;
    box.put(id, attendance);
  }
  Attendance? get(int id){
    return box.get(id);
  }

  void delete(int id){
    box.delete(id);
  }
  void update(Attendance attendance){
    box.put(attendance.id, attendance);
  }

  void closeBox(){
    box.close();
  }
}