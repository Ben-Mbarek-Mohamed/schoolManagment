import 'package:hive/hive.dart';
import 'package:madrasti/models/user.dart';

class UserService {
  Box<User> box = Hive.box<User>('users');

  List<User> getAll(){
    return box.values.toList().cast<User>();
  }

  Future<User> add(User user) async {
    int id = await box.add(user);
    user.id = id;
    box.put(id, user);
    return user;
  }
  User? get(int id){
    return box.get(id);
  }

  void delete(int id){
    box.delete(id);
  }
  void update(User user){
    box.put(user.id, user);
  }

  void closeBox(){
    box.close();
  }
}