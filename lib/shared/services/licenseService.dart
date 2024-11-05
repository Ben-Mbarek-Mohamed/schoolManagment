import 'package:hive/hive.dart';

class LicenseService{
  Box<DateTime> box = Hive.box<DateTime>('free_trial');
  Box<bool> box2 = Hive.box<bool>('activated');

  DateTime? get(int id){
    return box.get(id);
  }
  void startFreeTrial(DateTime date) {
    box.put(0, date);
  }

  void activate(){
    box2.put(0, true);
  }

  bool isActivated(){
    bool val = box2.get(0) ?? false;
    return val;
  }

  bool isFreeTrialStarted(){
    DateTime? date = box.get(0);
    if(date == null){
      return false;
    }
    else {
      return true;
    }
  }
  bool isFreeTrialEnded(){
    DateTime? date = box.get(0);
    if(date == null){
      return false;
    }
    else {
      if(3 -
          DateTime.now()
              .difference(getFreeTrialDate())
              .inDays> 0){
        return false;
      }
      else{
        return true;
      }
    }
  }
  DateTime getFreeTrialDate(){
    return box.get(0)!;
  }


  void closeBox(){
    box.close();
  }
}