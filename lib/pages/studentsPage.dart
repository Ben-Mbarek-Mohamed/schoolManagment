import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:madrasti/models/student.dart';
import 'package:madrasti/providers/studentProvider.dart';
import 'package:madrasti/shared/services/attendanceService.dart';
import 'package:madrasti/shared/services/studentService.dart';
import 'package:madrasti/shared/widgets/add/addStudent.dart';
import 'package:madrasti/shared/widgets/search/searchStudent.dart';
import 'package:provider/provider.dart';

import '../language_utils/language_constants.dart';
import '../models/group.dart';
import '../models/notification.dart';
import '../shared/pdfUtils/generateStudentList.dart';
import '../shared/services/grouService.dart';
import '../shared/services/notificationService.dart';
import '../shared/widgets/update/updateStudent.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  StudentService studentService = StudentService();

  @override
  void initState() {
    // TODO: implement initState
    getData(context, studentService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<StudentProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: size.width * 0.75 + 50,
          height: size.height * 0.8 + 50,
          child: PaginatedDataTable(
            showFirstLastButtons: true,
            arrowHeadColor: Colors.blueAccent,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () async {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          const Dialog(child: AddStudent()),
                    );
                  },
                  tooltip: translation(context).add,
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    if (getFiltredStudents(context) != null) {
                      generateStudentsPdf(getFiltredStudents(context), context,DateFormat('yyyy-MM-dd').format(DateTime.now()));
                    }
                  },
                  tooltip: translation(context).print,
                  icon: const Icon(
                    Icons.print,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ),
            ],
            columns: getColumns(context),
            source: RowSource(
                context: context,
                count: getFiltredStudents(context)!.length,
                myData: getFiltredStudents(context)!),
            rowsPerPage: 8,
            columnSpacing: 20,
            header: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                  tooltip: translation(context).search,
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: Container(
                          child: Container(
                            child: const SearchStudent(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      setFiltredStudents(studentService.getAll(), context);
                      setAllStudents(studentService.getAll(), context);
                    });
                  },
                  tooltip: translation(context).refresh,
                  icon: const Icon(
                    Icons.restart_alt,
                    color: Colors.red,
                    size: 40,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RowSource extends DataTableSource {
  final BuildContext context;
  var myData;
  final count;

  RowSource({
    required this.context,
    required this.myData,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData[index], context);
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  int _getAbsences(int stdId) {
    AttendanceService attendanceService = AttendanceService();
    return attendanceService
        .getAll()
        .where((element) =>
            element.absentStudent!.contains(stdId) && element.isProfPresent!)
        .length;
  }

  DataRow recentFileDataRow(Student data, BuildContext context) {
    return DataRow(cells: [
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: UpdateStudent(
                selectedStudent: data,
              )),
            );
          },
          child: Text(data.registrationNumber!),
        ),
      ),
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: UpdateStudent(
                selectedStudent: data,
              )),
            );
          },
          child: Text(data.firstName!),
        ),
      ),
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: UpdateStudent(
                selectedStudent: data,
              )),
            );
          },
          child: Text(data.lastName!),
        ),
      ),
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: UpdateStudent(
                selectedStudent: data,
              )),
            );
          },
          child: Container(
            height: 70,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.1),
              color: (getRequiredAmmount(data, context) <= 0)
                  ? Colors.green.withOpacity(0.9)
                  : Colors.red.withOpacity(0.9),
            ),
            alignment: Alignment.center,
            child: (getRequiredAmmount(data, context) != 0)
                ? Text(
                    getRequiredAmmount(data, context).abs().toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  )
                : Icon(
                    Icons.done,
                    color: Colors.black,
                    size: 40,
                  ),
          ),
        ),
      ),
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: UpdateStudent(
                selectedStudent: data,
              )),
            );
          },
          child: Text(DateFormat('yyyy-MM-dd').format(data.registrationDate!)),
        ),
      ),
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: UpdateStudent(
                selectedStudent: data,
              )),
            );
          },
          child: Text(DateFormat('yyyy-MM-dd').format(data.birthDate!)),
        ),
      ),
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: UpdateStudent(
                selectedStudent: data,
              )),
            );
          },
          child: Text(_getAbsences(data.id!).toString()),
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
    DataColumn(
      label: Text(
        translation(context).required_amount,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).reg_date,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).birth_date,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        (translation(context).attendance == 'Attendance')
            ? 'absence'
            : translation(context).attendance.split(" ").last,
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

getData(context, StudentService studentService) async {
  List<Student>? students = await studentService.getAll();
  setAllStudents(students, context);
  setFiltredStudents(students, context);
}

List<DateTime> getDates(DateTime startDate, DateTime endDate) {
  List<DateTime> dates = [];

  // Start from the next month with the same day as the start date
  DateTime currentDate =
      DateTime(startDate.year, startDate.month, startDate.day );

  while (
      currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
    // Calculate the number of days in the current month
    int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;

    // Adjust the day if the current month has fewer days
    int day = startDate.day <= daysInMonth ? startDate.day : daysInMonth;

    dates.add(DateTime(currentDate.year, currentDate.month, day));

    // Move to the same day in the next month, adjusting if necessary
    currentDate = DateTime(currentDate.year, currentDate.month + 1, 1);
    daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    currentDate = DateTime(currentDate.year, currentDate.month,
        startDate.day <= daysInMonth ? startDate.day : daysInMonth);
  }
  return dates;
}

double getRequiredAmmount(Student student, context) {
  GroupService groupService = GroupService();
  StudentService studentService = StudentService();
  NotificationService notificationService = NotificationService();
  double result = 0;
  for (Ammount ammount in student.requiredAmmount!) {
    result += ammount.ammount!;
  }
  for (Ammount ammount in student.payedAmmount!) {
    result -= ammount.ammount!;
  }
  if (student != null && student.groups != null) {
    List<int> groupsIds = student.groups!;
    for (int id in groupsIds) {
      Groupe groupe = groupService.get(id)!;
      if (groupe.isRegular!) {
        String stdInfo = groupe.studentsId!.firstWhere(
            ((element) => element.split('?').first == student.id!.toString()));
        DateTime regDate = DateTime.parse(stdInfo.split('?').last);
        List<DateTime> dates = getDates(regDate, groupe.endDate!);
        for (DateTime date in dates) {
          if (DateTime.now().isAfter(date)) {
            if (!student.requiredAmmount!.any((element) =>
                element.date == date && element.groupId == groupe.id)) {
              Ammount ammount = Ammount(
                  name: 'required',
                  isExpence: false,
                  personId: student.id,
                  groupId: groupe.id,
                  date: date,
                  ammount: groupe.studentPrice);
              student.requiredAmmount!.add(ammount);
              NotificationModel notification = NotificationModel(
                  date: DateTime.now(),
                  isStudent: true,
                  name: student.firstName! + ' ' + student.lastName!,
                  ammount: ammount.ammount!);
              notificationService.add(notification);
              studentService.update(student);
              getData(context, studentService);
            }
          }
        }
      }
    }
  }

  return result;
}
