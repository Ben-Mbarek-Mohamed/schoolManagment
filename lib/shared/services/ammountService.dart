import 'package:hive/hive.dart';
import 'package:madrasti/models/ammount.dart';

class AmmountService{
  Box<Ammount> box = Hive.box<Ammount>('ammounts');

  List<Ammount> getAll(){
    return box.values.toList().cast<Ammount>();
  }

  Future<void> add(Ammount ammount) async {
    int id = await box.add(ammount);
    ammount.id = id;
    box.put(id, ammount);
  }
  Ammount? get(int id){
    return box.get(id);
  }

  void delete(int id){
    box.delete(id);
  }
  void update(Ammount ammount){
    box.put(ammount.id, ammount);
  }

  void closeBox(){
    box.close();
  }
}