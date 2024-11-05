import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/prof.dart';

class ProfProvider extends ChangeNotifier{
  List<Prof>? allProfs = [];
  List<Prof>? filtredProfs = [];
  Prof? prof;

  void setAllProfs(List<Prof>? allProfs){
    this.allProfs = allProfs;
    notifyListeners();
  }
  void setFiltredProfs(List<Prof>? filtredProfs){
    this.filtredProfs = filtredProfs;
    notifyListeners();
  }
  void setProf(Prof? prof){
    this.prof = prof;
    notifyListeners();
  }
}

void setAllProfs(List<Prof>? allProfs, context){
  Provider.of<ProfProvider>(context, listen: false).setAllProfs(allProfs);
}
List<Prof>? getAllProfs(context){
  return Provider.of<ProfProvider>(context, listen: false).allProfs;
}

void setFiltredProfs(List<Prof>? filtredProfs, context){
  Provider.of<ProfProvider>(context, listen: false).setFiltredProfs(filtredProfs);
}
List<Prof>? getFiltredProfs(context){
  return Provider.of<ProfProvider>(context, listen: false).filtredProfs;
}

void setProf(Prof? prof, context){
  return Provider.of<ProfProvider>(context, listen: false).setProf(prof);
}
Prof? getProf(context){
  return Provider.of<ProfProvider>(context, listen: false).prof;
}