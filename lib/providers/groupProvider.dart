
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../models/group.dart';
class GroupProvider extends ChangeNotifier {
  List<Groupe>? allGroups = [];
  List<Groupe>? filtredGroups = [];
  Groupe? groupe;

  void setAllGroups(List<Groupe>? groups){
    this.allGroups = groups;
    notifyListeners();
  }
  void setFiltredGroups(List<Groupe>? groups){
    this.filtredGroups = groups;
    notifyListeners();
  }
  void setGroupe(Groupe? groupe){
    this.groupe = groupe;
    notifyListeners();
  }
}

setAllGroups(context, List<Groupe>? groups){
  Provider.of<GroupProvider>(context,listen: false).setAllGroups(groups);
}

List<Groupe>? getAllGroups(context){
  Provider.of<GroupProvider>(context,listen: false).allGroups;
}

setFiltredGroups(context, List<Groupe>? groups){
  Provider.of<GroupProvider>(context,listen: false).setFiltredGroups(groups);
}

List<Groupe>? getFiltredGroups(context){
  return Provider.of<GroupProvider>(context,listen: false).filtredGroups;
}

setGroup(context, Groupe? groupe){
  Provider.of<GroupProvider>(context,listen: false).setGroupe(groupe);
}
Groupe? getGroup(context){
  return Provider.of<GroupProvider>(context,listen: false).groupe;
}