import 'package:flutter/material.dart';
import 'package:madrasti/providers/groupProvider.dart';
import 'package:madrasti/shared/services/grouService.dart';
import 'package:madrasti/shared/widgets/search/searchStudentInGroup.dart';
import 'package:provider/provider.dart';

import '../../../language_utils/language_constants.dart';
import '../../../models/group.dart';
import '../../../models/student.dart';
import '../../../providers/studentProvider.dart';
import '../../services/studentService.dart';
class AddStudentToGroup extends StatefulWidget {
  final Groupe? groupe;
  const AddStudentToGroup({super.key, required this.groupe});

  @override
  State<AddStudentToGroup> createState() => _AddStudentToGroupState();
}

class _AddStudentToGroupState extends State<AddStudentToGroup> {
  StudentService studentService = StudentService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context, studentService);
  }
  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<StudentProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
        width: 700,
        child: PaginatedDataTable(

          showFirstLastButtons: true,
          arrowHeadColor: Colors.blueAccent,
          actions: [

          ],
          columns: getColumns(context),
          source: RowSource(context: context, count: getFiltredStudents(context)!.length, myData: getFiltredStudents(context)!,groupe: widget.groupe),
          rowsPerPage: 8,
          columnSpacing: 60,
          header: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.blueAccent,
                  size: 40,
                ),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => const Dialog(
                      child: SearchStudentInGroup(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 30,),
              IconButton(onPressed: (){
                setState(() {
                  setFiltredStudents(studentService.getAll(), context);
                  setAllStudents(studentService.getAll(), context);
                });
              }, icon: const Icon(
                Icons.restart_alt,
                color: Colors.red,
                size: 40,
              ),
              )
            ],
          ),
        ),
    );
  }
}


class RowSource extends DataTableSource {
  final BuildContext context;
  var myData;
  final count;
  Groupe? groupe;

  RowSource({
    required this.context,
    required this.myData,
    required this.count,
    required this.groupe,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData[index], context, groupe);
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  DataRow recentFileDataRow(Student data, BuildContext context,Groupe? groupe) {
    StudentService studentService = StudentService();
    GroupService groupService = GroupService();
    return DataRow(cells: [
      DataCell(
        GestureDetector(
          onTap: (){
            if(groupe != null){
              if(groupe.studentsId!.map((e) => e.split('?').first).toList().contains(data.id.toString())){
                print(groupe.studentsId!.map((e) => e.split('?').first).toList());
                Navigator.of(context).pop();
              }
              else{
                Groupe gr = groupe;
                gr.studentsId!.add('${data.id!}?${DateTime.now()}');
                groupService.update(gr);
                Student std = data;
                std.groups!.add(gr.id!);
                studentService.update(std);
                setFiltredStudents(studentService.getAll(), context);
                setFiltredGroups(context, groupService.getAll());
                Navigator.of(context).pop();
              }
            }

          },
            child: Text(data.registrationNumber!),
        ),
      ),
      DataCell(
        GestureDetector(
          onTap: (){
            if(groupe != null){
              if(groupe.studentsId!.map((e) => e.split('?').first).toList().contains(data.id.toString())){
                Navigator.of(context).pop();
              }
              else{
                Groupe gr = groupe;
                gr.studentsId!.add('${data.id!}?${DateTime.now()}');
                groupService.update(gr);
                Student std = data;
                std.groups!.add(gr.id!);
                studentService.update(std);
                setFiltredStudents(studentService.getAll(), context);
                setFiltredGroups(context, groupService.getAll());
                Navigator.of(context).pop();
              }
            }
          },
            child: Text(data.firstName!),
        ),
      ),
      DataCell(
        GestureDetector(
          onTap: (){
            if(groupe != null){
              if(groupe.studentsId!.map((e) => e.split('?').first).toList().contains(data.id.toString())){
                print(groupe.studentsId!.map((e) => e.split('?').first).toList());
                Navigator.of(context).pop();
              }
              else{
                Groupe gr = groupe;
                gr.studentsId!.add('${data.id!}?${DateTime.now()}');
                groupService.update(gr);
                Student std = data;
                std.groups!.add(gr.id!);
                studentService.update(std);
                setFiltredStudents(studentService.getAll(), context);
                setFiltredGroups(context, groupService.getAll());
                Navigator.of(context).pop();
              }
            }
          },
          child: Text(data.lastName!),
        ),
      ),
    ]);
  }
}

List<DataColumn> getColumns(context) {
  return [
    DataColumn(
      label: Text(
        translation(context).reg_number,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).first_name,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).last_name,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
  ];
}

List<DataRow> getRows(var data, context) {
  return [DataRow(cells: getCells(context))];
}

List<DataCell> getCells(List<dynamic> cells) => cells
    .map((e) => (e is Widget) ? DataCell(e) : DataCell(Text('${e}')))
    .toList();

getData(context,StudentService studentService) async{
  List<Student>? students = await studentService.getAll();
  setAllStudents(students, context);
  setFiltredStudents(students, context);
}

