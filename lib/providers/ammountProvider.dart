import 'package:flutter/material.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:provider/provider.dart';

class AmmountProvider extends ChangeNotifier{
  List<Ammount>? allAmmounts = [];

  void setAllAmmounts(List<Ammount>? allAmmounts){
    this.allAmmounts = allAmmounts;
    notifyListeners();
  }
}

void setAllAmmounts(List<Ammount>? allAmmounts, context){
  return Provider.of<AmmountProvider>(context,listen: false).setAllAmmounts(allAmmounts);
}
List<Ammount>? getAllAmmounts(context){
  return Provider.of<AmmountProvider>(context,listen: false).allAmmounts;
}