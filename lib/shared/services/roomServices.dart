import 'package:hive/hive.dart';
import 'package:madrasti/models/room.dart';

class RoomService {
  Box<Room> box = Hive.box<Room>('rooms');

  List<Room> getAll(){
    return box.values.toList().cast<Room>();
  }

  Future<Room> add(Room room) async {
    int id = await box.add(room);
    room.id = id;
    box.put(id, room);
    return room;
  }
  Room? get(int id){
    return box.get(id);
  }

  void delete(int id){
    box.delete(id);
  }
  void update(Room room){
    box.put(room.id, room);
  }

  void closeBox(){
    box.close();
  }
}