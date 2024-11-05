import 'package:hive/hive.dart';
import 'package:madrasti/models/student.dart';

class StudentService{

  Box<Student> box = Hive.box<Student>('students');

  Future<Student> add(Student student) async {
    int id = await box.add(student);
    student.id = id;
    int regNum = int.parse(student.registrationNumber!);
    int newRegNum = regNum + id;
    student.registrationNumber = newRegNum.toString();
    box.put(id, student);
    return student;
  }

  List<Student> getAll(){
    return box.values.toList().cast<Student>();
  }

  Student? get(int id){
    return box.get(id);
  }

  void delete(int id){
    box.delete(id);
  }

  void update(Student student){
    box.put(student.id, student);
  }

  void closeBox(){
    box.close();
  }
}