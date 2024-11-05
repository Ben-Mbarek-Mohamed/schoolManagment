import 'package:flutter/material.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:provider/provider.dart';

class ExpencesProvider extends ChangeNotifier{
  List<Ammount>? allExpences = [];

  void setAllExpences(List<Ammount>? allExpences){
    this.allExpences = allExpences;
    notifyListeners();
  }
}

void setAllExpences(List<Ammount>? allExpences, context){
  return Provider.of<ExpencesProvider>(context,listen: false).setAllExpences(allExpences);
}
List<Ammount>? getAllExpences(context){
  return Provider.of<ExpencesProvider>(context,listen: false).allExpences;
}