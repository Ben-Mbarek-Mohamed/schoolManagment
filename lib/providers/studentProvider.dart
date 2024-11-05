
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



import '../models/student.dart';

class StudentProvider extends ChangeNotifier{
  List<Student>? allStudents = [];
  List<Student>? filtredStudents = [];
  Student? student;

  void setAllStudents(List<Student>? allStudents){
    this.allStudents = allStudents;
    notifyListeners();
  }
  void setFiltredStudents(List<Student>? students){
    this.filtredStudents = students;
    notifyListeners();
  }

  void setStudent( Student? student){
    this.student = student;
    notifyListeners();
  }
}

void setAllStudents(List<Student>? allStudents, context){
  Provider.of<StudentProvider>(context, listen: false).setAllStudents(allStudents);
}
List<Student>? getAllStudents(context){
  return Provider.of<StudentProvider>(context, listen: false).allStudents;
}

void setFiltredStudents(List<Student>? students, context){
  Provider.of<StudentProvider>(context, listen: false).setFiltredStudents(students);
}
List<Student>? FiltredStudents(context){
  return Provider.of<StudentProvider>(context, listen: false).filtredStudents;
}
List<Student>? getFiltredStudents(context){
  return Provider.of<StudentProvider>(context, listen: false).filtredStudents;
}

void setStudent( Student? student,context){
  Provider.of<StudentProvider>(context, listen: false).setStudent(student);
}
Student? getStudent(context){
  return Provider.of<StudentProvider>(context, listen: false).student;
}
