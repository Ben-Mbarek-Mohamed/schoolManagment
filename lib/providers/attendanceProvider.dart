import 'package:flutter/material.dart';
import 'package:madrasti/models/attendance.dart';
import 'package:provider/provider.dart';

class AttendanceProvider extends ChangeNotifier{
  List<Attendance>? allAttendance = [];

  void setAllAttendance(List<Attendance>? allAttendance){
    this.allAttendance = allAttendance;
    notifyListeners();
  }
}
void setAllAttendance(List<Attendance>? allAttendance, context){
  return Provider.of<AttendanceProvider>(context,listen: false).setAllAttendance(allAttendance);
}
List<Attendance>? getAllAttendance(context){
  return Provider.of<AttendanceProvider>(context,listen: false).allAttendance;
}