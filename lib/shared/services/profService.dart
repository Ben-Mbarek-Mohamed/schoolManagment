import 'package:hive/hive.dart';
import 'package:madrasti/models/prof.dart';

class ProfService{
  Box<Prof> box = Hive.box<Prof>('teachers');

  Future<Prof> add(Prof prof) async {
    int id = await box.add(prof);
    prof.id = id;
    int regNum = int.parse(prof.registrationNumber!);
    int newRegNum = regNum + id;
    prof.registrationNumber = newRegNum.toString();
    box.put(id, prof);
    return prof;
  }

  List<Prof> getAll(){
    return box.values.toList().cast<Prof>();
  }

  Prof? get(int id){
    return box.get(id);
  }

  void delete(int id){
    box.delete(id);
  }

  void update(Prof prof){
    box.put(prof.id, prof);
  }

  void closeBox(){
    box.close();
  }
}