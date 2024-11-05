import 'package:hive/hive.dart';
import 'package:madrasti/models/schedule.dart';


class ScheduleService{

  Box<Schedule> box = Hive.box<Schedule>('schedules');

  Future<Schedule> add(Schedule schedule) async {
    int id = await box.add(schedule);
    schedule.id = id;

    box.put(id, schedule);
    return schedule;
  }

  List<Schedule> getAll(){
    return box.values.toList().cast<Schedule>();
  }

  Schedule? get(int id){
    return box.get(id);
  }

  void delete(int id){
    box.delete(id);
  }

  void update(Schedule schedule){
    box.put(schedule.id, schedule);
  }

  void closeBox(){
    box.close();
  }
}