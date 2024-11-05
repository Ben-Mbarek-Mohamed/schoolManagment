import 'package:flutter/material.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier{
  User? currentUser;

  void setCurrentUser(User? currentUser){
    this.currentUser = currentUser;
    notifyListeners();
  }
}

void setCurrentUser(User? currentUser, context){
  return Provider.of<UserProvider>(context,listen: false).setCurrentUser(currentUser);
}
User? getCurrentUser(context){
  return Provider.of<UserProvider>(context,listen: false).currentUser;
}