import 'package:hive/hive.dart';
import 'package:madrasti/models/group.dart';

class GroupService {

  Box<Groupe> box = Hive.box<Groupe>('groups');

  List<Groupe> getAll(){
    return box.values.toList().cast<Groupe>();
  }

  Future<void> add(Groupe groupe) async {
    int id = await box.add(groupe);
    groupe.id = id;
    box.put(id, groupe);
  }
  Groupe? get(int id){
    return box.get(id);
  }

  void delete(int id){
    box.delete(id);
  }
  void update(Groupe groupe){
    box.put(groupe.id, groupe);
  }

  void closeBox(){
    box.close();
  }
}
