
import 'package:flutter/material.dart';
import 'package:madrasti/models/room.dart';
import 'package:provider/provider.dart';

class RoomProvider extends ChangeNotifier{
  List<Room>? allRooms =  [];
  List<Room>? filtredRooms =  [];

  void setAllRooms(List<Room>? rooms){
    this.allRooms = rooms;
    notifyListeners();
  }
  void setFiltredRooms(List<Room>? rooms){
    this.filtredRooms = rooms;
    notifyListeners();
  }
}

setAllRooms(context, List<Room>? rooms){
  Provider.of<RoomProvider>(context,listen: false).setAllRooms(rooms);
}

List<Room>? getAllRooms(context){
  Provider.of<RoomProvider>(context,listen: false).allRooms;
}

setFiltredRooms(context, List<Room>? rooms){
  Provider.of<RoomProvider>(context,listen: false).setFiltredRooms(rooms);
}

List<Room>? getFiltredRooms(context){
  return Provider.of<RoomProvider>(context,listen: false).filtredRooms;
}
