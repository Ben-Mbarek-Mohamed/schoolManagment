import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:madrasti/models/attendance.dart';
import 'package:madrasti/models/student.dart';
import 'package:madrasti/providers/attendanceProvider.dart';
import 'package:madrasti/shared/pdfUtils/generatePresences.dart';
import 'package:madrasti/shared/services/attendanceService.dart';
import 'package:madrasti/shared/services/grouService.dart';
import 'package:madrasti/shared/services/notificationService.dart';
import 'package:madrasti/shared/services/profService.dart';
import 'package:madrasti/shared/services/studentService.dart';
import 'package:provider/provider.dart';

import '../language_utils/language_constants.dart';
import '../models/group.dart';
import '../models/notification.dart';
import '../models/prof.dart';
import '../models/sessionTime.dart';
import '../shared/pdfUtils/generateAbsences.dart';

class AttendencePage extends StatefulWidget {
  final FocusNode focusNode;
  final VoidCallback? onDispose;

  const AttendencePage({super.key, required this.focusNode, this.onDispose});

  @override
  State<AttendencePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendencePage> {
  List<Groupe>? groups = [];
  Groupe? currentGroupe;
  Attendance? currentAttendance;
  DateTime date = DateTime.now();

  GroupService groupService = GroupService();
  StudentService studentService = StudentService();
  ProfService profService = ProfService();
  AttendanceService attendanceService = AttendanceService();
  NotificationService notificationService = NotificationService();
  final TextEditingController _regNumController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void dispose() {
    //widget.focusNode.dispose();
    widget.onDispose?.call(); // Notify the parent widget if needed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadGroups();
    _checkAttendance();
  }

  bool isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  void _updateButtonState() {
    final isNotEmpty = _regNumController.text.isNotEmpty;
    if (_isButtonEnabled != isNotEmpty) {
      setState(() {
        _isButtonEnabled = isNotEmpty;
      });
    }
  }

  Future<void> _checkAttendance() async {
    if (currentGroupe != null) {
      final today = DateFormat('yyyy-MM-dd').format(date);
      List<Attendance> attendances = attendanceService.getAll();
      bool exist = attendances.any((element) =>
          DateFormat('yyyy-MM-dd').format(element.date!) == today &&
          element.groupId == currentGroupe!.id);
      if (exist) {
        setState(() {
          currentAttendance = attendanceService.getAll().firstWhere((element) =>
              DateFormat('yyyy-MM-dd').format(element.date!) == today &&
              element.groupId == currentGroupe!.id);
        });
      } else {
        Attendance newAttendance = Attendance(
          groupId: currentGroupe!.id,
          date: date,
          isProfPresent: false,
          presentStudent: [],
          presentProf: [],
          absentStudent: (isToday(date))
              ? currentGroupe!.studentsId!
                  .map((e) => int.tryParse(e.split('?').first)!)
                  .toList()
              : [],
          absentProf: (isToday(date))
              ? currentGroupe!.profsId!
                  .map((e) => int.tryParse(e.split('?').first)!)
                  .toList()
              : [],
        );
        await attendanceService.add(newAttendance);
        setState(() {
          currentAttendance = attendanceService.getAll().firstWhere((element) =>
              DateFormat('yyyy-MM-dd').format(element.date!) == today &&
              element.groupId == currentGroupe!.id);
        });
      }
    }
  }

  void _loadGroups() {
    setState(() {
      groups = groupService.getAll();
      _filterGroupsByDay(date);
      currentGroupe ??=
          (groups != null && groups!.isNotEmpty) ? groups!.first : null;
    });
  }

  void _filterGroupsByDay(DateTime selectedDate) {
    if (groups == null || groups!.isEmpty) return;

    final dayMap = {
      DateTime.monday: 'monday',
      DateTime.tuesday: 'tuesday',
      DateTime.wednesday: 'wednesday',
      DateTime.thursday: 'thursday',
      DateTime.friday: 'friday',
      DateTime.saturday: 'saturday',
      DateTime.sunday: 'sunday',
    };

    final selectedDay = dayMap[selectedDate.weekday];

    groups = groups!.where((group) {
      return haveCommonElement(group.sessionDays!, [selectedDay!]) &&
          ((date.isAfter(group.startDate!) ||
                  date.isAtSameMomentAs(group.startDate!)) &&
              (date.isBefore(group.endDate!) ||
                  date.isAtSameMomentAs(group.endDate!)));
    }).toList();
  }

  List<Student>? _getAbsentStudents() {
    List<Student> students = [];
    if (currentAttendance != null) {
      List<int> studentIds = currentAttendance!.absentStudent!;
      if (currentGroupe != null) {
        List<int> stdIds = currentGroupe!.studentsId!
            .map((e) => int.tryParse(e.split('?').first)!)
            .toList();
        for (int id in stdIds) {
          if (!currentAttendance!.absentStudent!.contains(id) &&
              !currentAttendance!.presentStudent!.contains(id) &&
              isToday(date)) {
            setState(() {
              currentAttendance!.absentStudent!.add(id);
            });

            attendanceService.update(currentAttendance!);
            if (currentAttendance!.isProfPresent == true
             && currentGroupe!.isRegular == false
            ) {
              double ammount = currentGroupe!.studentPrice!;
              Student currentStudent = studentService.get(id)!;
              Ammount amt = Ammount(
                  date: date,
                  groupId: currentGroupe!.id,
                  personId: currentStudent.id,
                  isExpence: false,
                  ammount: ammount,
                  name: 'required');
              currentStudent.requiredAmmount!.add(amt);
              studentService.update(currentStudent);
              NotificationModel notification = NotificationModel(
                  date: DateTime.now(),
                  isStudent: true,
                  name:
                      '${currentStudent.firstName!} ${currentStudent.lastName!}',
                  ammount: amt.ammount);
              notificationService.add(notification);
            }
          }
        }
      }
      for (int id in studentIds) {
        Student? std = studentService.get(id);
        if (std != null) {
          students.add(std);
        }
      }
    }
    return students;
  }

  List<Prof>? _getAbsentProfs() {
    List<Prof> profs = [];
    if (currentAttendance != null) {
      List<int> profIds = currentAttendance!.absentProf!;

      if (currentGroupe != null) {
        List<int> prfIds = currentGroupe!.profsId!
            .map((e) => int.tryParse(e.split('?').first)!)
            .toList();
        for (int id in prfIds) {
          if (!currentAttendance!.absentProf!.contains(id) &&
              !currentAttendance!.presentProf!.contains(id) &&
              isToday(date)) {
            setState(() {
              currentAttendance!.absentProf!.add(id);
            });
            attendanceService.update(currentAttendance!);
          }
        }
      }
      for (int id in profIds) {
        Prof? prf = profService.get(id);
        if (prf != null) {
          profs.add(prf);
        }
      }
    }
    return profs;
  }

  List<Prof>? _getPresentProfs() {
    List<Prof> profs = [];
    if (currentAttendance != null) {
      List<int> profIds = currentAttendance!.presentProf!;

      for (int id in profIds) {
        Prof? prf = profService.get(id);
        if (prf != null) {
          profs.add(prf);
        }
      }
    }
    return profs;
  }

  List<Student>? _getPresentStudents() {
    List<Student> students = [];
    if (currentAttendance != null) {
      List<int> studentIds = currentAttendance!.presentStudent!;
      for (int id in studentIds) {
        Student? std = studentService.get(id);
        if (std != null) {
          students.add(std);
        }
      }
    }
    return students;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var provider = Provider.of<AttendanceProvider>(context);
    final List<Student> absentStudents = _getAbsentStudents()!;
    final List<Student> presentStudents = _getPresentStudents()!;
    final List<Prof> absentProfs = _getAbsentProfs()!;
    final List<Prof> presentProfs = _getPresentProfs()!;
    _loadGroups();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('${translation(context).group} : '),
                    const SizedBox(width: 0),
                    if (currentGroupe != null)
                      SizedBox(
                        width: 160,
                        child: DropdownButton<Groupe>(
                          hint: Text(translation(context).groups),
                          value: currentGroupe,
                          items: groups!.map((Groupe item) {
                            return DropdownMenuItem<Groupe>(
                              value: item,
                              child: Text(item.name!),
                            );
                          }).toList(),
                          onChanged: (Groupe? value) {
                            setState(() {
                              currentGroupe = value;
                              _checkAttendance();
                            });
                          },
                        ),
                      )
                    else
                      const SizedBox(width: 100),
                    const SizedBox(width: 40),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && date != picked) {
                          setState(() {
                            date = picked;
                            _loadGroups();
                            _checkAttendance();
                          });
                        }
                      },
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(date),
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blueAccent),
                        fixedSize: MaterialStatePropertyAll(Size(150, 40)),
                        elevation: MaterialStatePropertyAll(5),
                      ),
                    ),
                    (isToday(date))
                        ? const SizedBox(
                            width: 140,
                          )
                        : const SizedBox(
                            width: 50,
                          ),
                    const SizedBox(
                      width: 20,
                    ),
                    (isToday(date))
                        ? SizedBox(
                            height: 40,
                            width: 200,
                            child: TextFormField(
                              autofocus: true,
                              focusNode: widget.focusNode,
                              controller: _regNumController,
                              onChanged: (val) {
                                _updateButtonState();
                                if (val.length == 10 &&
                                    val.toString().startsWith('17205')) {
                                  setState(() {
                                    if (currentAttendance!.absentStudent!
                                        .map((e) => e + 1720557913)
                                        .contains(int.tryParse(
                                            _regNumController.text))) {
                                      currentAttendance!.absentStudent!.remove(
                                          int.tryParse(
                                                  _regNumController.text)! -
                                              1720557913);
                                      currentAttendance!.presentStudent!.add(
                                          int.tryParse(
                                                  _regNumController.text)! -
                                              1720557913);
                                      attendanceService
                                          .update(currentAttendance!);

                                      _regNumController.clear();
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            Future.delayed(
                                                const Duration(seconds: 3), () {
                                              Navigator.of(context).pop();
                                            });
                                            return Dialog(
                                              elevation: 2,
                                              backgroundColor:
                                                  Colors.red.withOpacity(0.5),
                                              child: SizedBox(
                                                height: 80,
                                                width: 500,
                                                child: Center(
                                                  child: Text(
                                                    translation(context)
                                                        .invalid_reg_num,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 25),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  });
                                  _regNumController.clear();
                                }
                                if (val.length == 12 &&
                                    val.toString().startsWith('1117205')) {
                                  setState(() {
                                    if (currentAttendance != null &&
                                        currentGroupe != null) {
                                      if (currentAttendance!.absentProf!
                                          .map((e) => e + 111720557913)
                                          .contains(int.tryParse(
                                              _regNumController.text))) {
                                        currentAttendance!.absentProf!.remove(
                                            int.tryParse(
                                                    _regNumController.text)! -
                                                111720557913);
                                        currentAttendance!.presentProf!.add(
                                            int.tryParse(
                                                    _regNumController.text)! -
                                                111720557913);
                                        attendanceService
                                            .update(currentAttendance!);

                                        if (currentGroupe!.isRegular == false) {
                                          double profAmmount = 0;
                                          if (currentGroupe!
                                              .isProfPaymentRegular!) {
                                            profAmmount =
                                                currentGroupe!.profPrice!;
                                          } else {
                                            profAmmount = (currentGroupe!
                                                        .profPoucentage! *
                                                    currentGroupe!
                                                        .studentsId!.length *
                                                    currentGroupe!
                                                        .studentPrice!) /
                                                100;
                                          }
                                          int parsedValue = int.parse(
                                              _regNumController.text.trim());
                                          int profID =
                                              parsedValue - 111720557913;
                                          Prof currentProf =
                                              profService.get(profID)!;
                                          Ammount due = Ammount(
                                              date: date,
                                              groupId: currentGroupe!.id,
                                              personId: currentProf.id,
                                              isExpence: false,
                                              ammount: profAmmount,
                                              name: 'required');
                                          currentProf.dueAmmount!.add(due);
                                          profService.update(currentProf);
                                          NotificationModel notification =
                                              NotificationModel(
                                                  date: DateTime.now(),
                                                  isStudent: false,
                                                  name:
                                                      '${currentProf.firstName!} ${currentProf.lastName!}',
                                                  ammount: due.ammount);
                                          notificationService.add(notification);
                                          if (currentAttendance!
                                                  .isProfPresent !=
                                              true) {
                                            for (int studentId in currentGroupe!
                                                .studentsId!
                                                .map((e) => int.parse(
                                                    e.split('?').first))) {
                                              double ammount =
                                                  currentGroupe!.studentPrice!;
                                              Student currentStudent =
                                                  studentService
                                                      .get(studentId)!;
                                              Ammount amt = Ammount(
                                                  date: date,
                                                  groupId: currentGroupe!.id,
                                                  personId: currentStudent.id,
                                                  isExpence: false,
                                                  ammount: ammount,
                                                  name: 'required');
                                              currentStudent.requiredAmmount!
                                                  .add(amt);
                                              studentService
                                                  .update(currentStudent);
                                              NotificationModel notification =
                                                  NotificationModel(
                                                      date: DateTime.now(),
                                                      isStudent: true,
                                                      name:
                                                          '${currentStudent.firstName!} ${currentStudent.lastName!}',
                                                      ammount: amt.ammount);
                                              notificationService
                                                  .add(notification);
                                            }
                                            currentAttendance!.isProfPresent =
                                                true;
                                            attendanceService
                                                .update(currentAttendance!);
                                          }
                                          setState(() {
                                            _regNumController.clear();
                                          });
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              Future.delayed(
                                                  const Duration(seconds: 3),
                                                  () {
                                                Navigator.of(context).pop();
                                              });
                                              return Dialog(
                                                elevation: 2,
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.5),
                                                child: SizedBox(
                                                  height: 80,
                                                  width: 500,
                                                  child: Center(
                                                    child: Text(
                                                      translation(context)
                                                          .invalid_reg_num,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 25),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      }
                                    }
                                  });

                                  _regNumController.clear();
                                }
                                if (val.length > 12) {
                                  _regNumController.clear();
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}')),
                              ],
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent)),
                                border: const OutlineInputBorder(),
                                labelText: translation(context).reg_number,
                                hintText: '1720557910',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    (!isToday(date))
                        ? Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            height: 55,
                            width: 420,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.red, width: 1),
                            ),
                            child: Text(
                              translation(context).attendance_date_message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    _buildStudentList(
                        context,
                        size,
                        presentStudents,
                        presentProfs,
                        Colors.green,
                        translation(context).present),
                    const SizedBox(width: 40),
                    _buildStudentList(context, size, absentStudents,
                        absentProfs, Colors.red, translation(context).absent),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentList(BuildContext context, Size size,
      List<Student> students, List<Prof> profs, Color color, String title) {
    bool isAbsences = title == translation(context).absent;
    return Container(
      width: size.width * 0.34,
      height: 1000,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      if (isAbsences) {
                        if (currentAttendance != null &&
                            currentGroupe != null) {
                          generateAbcencesPdf(
                              currentAttendance!, context, currentGroupe!,DateFormat('yyyy-MM-dd').format(date));
                        }
                      } else {
                        if (currentAttendance != null &&
                            currentGroupe != null) {
                          generatePresencesPdf(
                              currentAttendance!, context, currentGroupe!,DateFormat('yyyy-MM-dd').format(date));
                        }
                      }
                    },
                    tooltip: translation(context).print,
                    icon: Icon(
                      Icons.print,
                      color: isAbsences ? Colors.red : Colors.green,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translation(context).reg_number,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      translation(context).first_name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      translation(context).last_name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      translation(context).category,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ...students.map((student) => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                       Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Container(
                                        height: 300,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(translation(context).info, style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 25),),
                                            SizedBox(height: 40,),
                                            Text(translation(context).reg_number +' :' + student.registrationNumber!, style: TextStyle(fontSize: 18),),
                                            SizedBox(height: 20,),
                                            Text(translation(context).name +' :' + student.firstName!, style: TextStyle(fontSize: 18),),
                                            SizedBox(height: 20,),
                                            Text(translation(context).last_name +' :' + student.lastName!, style: TextStyle(fontSize: 18),),
                                            SizedBox(height: 20,),
                                            Text(translation(context).level +' :' + student.level!, style: TextStyle(fontSize: 18),),
                                            Spacer(),
                                            ElevatedButton(
                                                onPressed: (){
                                                  setState(() {
                                                    if (currentAttendance!.absentStudent!
                                                        .map((e) => e + 1720557913)
                                                        .contains(int.tryParse(
                                                        student.registrationNumber!))) {
                                                      currentAttendance!.absentStudent!.remove(
                                                          int.tryParse(
                                                              student.registrationNumber!)! -
                                                              1720557913);
                                                      currentAttendance!.presentStudent!.add(
                                                          int.tryParse(
                                                              student.registrationNumber!)! -
                                                              1720557913);
                                                      attendanceService.update(currentAttendance!);

                                                      _regNumController.clear();
                                                    }
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(translation(context).validate))

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(student.registrationNumber.toString()),
                                    Text(student.firstName.toString()),
                                    Text(student.lastName.toString()),
                                    Text(translation(context).student),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      )),
                  // Add some space between students and profs
                  ...profs.map((prof) => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Container(
                                          height: 300,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(translation(context).info, style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 25),),
                                              SizedBox(height: 40,),
                                              Text(translation(context).reg_number +' :' + prof.registrationNumber!, style: TextStyle(fontSize: 18),),
                                              SizedBox(height: 20,),
                                              Text(translation(context).name +' :' + prof.firstName!, style: TextStyle(fontSize: 18),),
                                              SizedBox(height: 20,),
                                              Text(translation(context).last_name +' :' + prof.lastName!, style: TextStyle(fontSize: 18),),
                                              SizedBox(height: 20,),
                                              Text(translation(context).major +' :' + prof.major!, style: TextStyle(fontSize: 18),),
                                              Spacer(),
                                              ElevatedButton(
                                                  onPressed: (){
                                                    setState(() {
                                                      if (currentAttendance != null &&
                                                          currentGroupe != null) {
                                                        if (currentAttendance!.absentProf!
                                                            .map((e) => e + 111720557913)
                                                            .contains(int.tryParse(
                                                            prof.registrationNumber!))) {
                                                          currentAttendance!.absentProf!.remove(
                                                              int.tryParse(
                                                                  prof.registrationNumber!)! -
                                                                  111720557913);
                                                          currentAttendance!.presentProf!.add(
                                                              int.tryParse(
                                                                  prof.registrationNumber!)! -
                                                                  111720557913);
                                                          setState(() {
                                                            currentAttendance!.isProfPresent = true;
                                                            attendanceService
                                                                .update(currentAttendance!);
                                                          });
                                                          if (currentGroupe!.isRegular == false) {
                                                            double profAmmount = 0;
                                                            if (currentGroupe!
                                                                .isProfPaymentRegular!) {
                                                              profAmmount = currentGroupe!.profPrice!;
                                                            } else {
                                                              profAmmount = (currentGroupe!
                                                                  .profPoucentage! *
                                                                  currentGroupe!
                                                                      .studentsId!.length *
                                                                  currentGroupe!.studentPrice!) /
                                                                  100;
                                                            }
                                                            int parsedValue =
                                                            int.parse(prof.registrationNumber!);
                                                            int profID = parsedValue - 111720557913;
                                                            Prof currentProf =
                                                            profService.get(profID)!;
                                                            Ammount due = Ammount(
                                                                date: date,
                                                                groupId: currentGroupe!.id,
                                                                personId: currentProf.id,
                                                                isExpence: false,
                                                                ammount: profAmmount,
                                                                name: 'required');
                                                            currentProf.dueAmmount!.add(due);
                                                            profService.update(currentProf);
                                                            NotificationModel notification =
                                                            NotificationModel(
                                                                date: DateTime.now(),
                                                                isStudent: false,
                                                                name:
                                                                '${currentProf.firstName!} ${currentProf.lastName!}',
                                                                ammount: due.ammount);
                                                            currentAttendance!.isProfPresent = true;
                                                            attendanceService
                                                                .update(currentAttendance!);
                                                            notificationService.add(notification);
                                                            if (currentAttendance!.isProfPresent ==
                                                                true && currentGroupe!.isRegular == false) {
                                                              for (int studentId in currentGroupe!
                                                                  .studentsId!
                                                                  .map((e) => int.parse(
                                                                  e.split('?').first))) {
                                                                double ammount =
                                                                currentGroupe!.studentPrice!;
                                                                Student currentStudent =
                                                                studentService.get(studentId)!;
                                                                Ammount amt = Ammount(
                                                                    date: date,
                                                                    groupId: currentGroupe!.id,
                                                                    personId: currentStudent.id,
                                                                    isExpence: false,
                                                                    ammount: ammount,
                                                                    name: 'required');
                                                                currentStudent.requiredAmmount!
                                                                    .add(amt);
                                                                studentService.update(currentStudent);
                                                                NotificationModel notification =
                                                                NotificationModel(
                                                                    date: DateTime.now(),
                                                                    isStudent: true,
                                                                    name:
                                                                    '${currentStudent.firstName!} ${currentStudent.lastName!}',
                                                                    ammount: amt.ammount);
                                                                notificationService.add(notification);
                                                              }
                                                              currentAttendance!.isProfPresent = true;
                                                              attendanceService
                                                                  .update(currentAttendance!);
                                                            }
                                                            setState(() {
                                                              _regNumController.clear();
                                                            });
                                                          }
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                Future.delayed(
                                                                    const Duration(seconds: 3), () {
                                                                  Navigator.of(context).pop();
                                                                });
                                                                return Dialog(
                                                                  elevation: 2,
                                                                  backgroundColor:
                                                                  Colors.red.withOpacity(0.5),
                                                                  child: SizedBox(
                                                                    height: 80,
                                                                    width: 500,
                                                                    child: Center(
                                                                      child: Text(
                                                                        translation(context)
                                                                            .invalid_reg_num,
                                                                        style: const TextStyle(
                                                                            color: Colors.white,
                                                                            fontWeight:
                                                                            FontWeight.w600,
                                                                            fontSize: 25),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        }
                                                      }
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(translation(context).validate))

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              );

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 91,
                                        child: Text(prof.registrationNumber.toString(),style: TextStyle(fontSize: 14),),
                                    ),
                                    Text(prof.firstName.toString()),
                                    Text(prof.lastName.toString()),
                                    Text(translation(context).teacher),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool haveCommonElement(List<SessionTime> list1, List<String> list2) {
  final set1 = Set<String>.from(list2);
  for (final element in list1) {
    if (set1.contains(element.day)) {
      return true;
    }
  }
  return false;
}
