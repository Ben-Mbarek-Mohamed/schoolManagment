import 'package:hive/hive.dart';
import 'package:madrasti/models/school.dart';


class SchoolService {
  Box<School> box = Hive.box<School>('school');

  List<School> getAll(){
    return box.values.toList().cast<School>();
  }

  Future<School> add(School school) async {
    int id = await box.add(school);
    school.id = id;
    box.put(id, school);
    return school;
  }
  School? get(int id){
    return box.get(id);
  }

  void delete(int id){
    box.delete(id);
  }
  void update(int id,School school){
    box.put(id, school);
  }

  void closeBox(){
    box.close();
  }
}