import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/shared/services/notificationService.dart';
import 'package:madrasti/shared/widgets/add/addProfToGroupe.dart';
import 'package:madrasti/shared/widgets/search/searchProfInGroup.dart';
import 'package:provider/provider.dart';

import '../language_utils/language_constants.dart';
import '../models/ammount.dart';
import '../models/group.dart';
import '../models/notification.dart';
import '../models/prof.dart';
import '../providers/profProvider.dart';
import '../shared/pdfUtils/generateProfsListInGroup.dart';
import '../shared/services/attendanceService.dart';
import '../shared/services/grouService.dart';
import '../shared/services/profService.dart';
import '../shared/widgets/update/updateProf.dart';

class ProfsInGroupPage extends StatefulWidget {
  const ProfsInGroupPage({super.key});

  @override
  State<ProfsInGroupPage> createState() => _ProfsInGroupPageState();
}

class _ProfsInGroupPageState extends State<ProfsInGroupPage> {
  List<Groupe>? groups = [];
  Groupe? currentGroupe;

  GroupService groupService = new GroupService();
  ProfService profService = new ProfService();

  @override
  void initState() {
    // TODO: implement initState
    getData(context, profService);
    this.groups = groupService.getAll();
    this.currentGroupe =
        (groups != null && groups!.isNotEmpty) ? groups!.first : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProfProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
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
                      builder: (BuildContext context) => Dialog(
                          child: AddProfToGroupe(
                        groupe: currentGroupe,
                      )),
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
                    if(currentGroupe != null){
                      generateProfsInGroupPdf(getFiltredProfs(context)!
                          .where((element) =>
                          element.groups!.contains(currentGroupe!.id))
                          .toList(),
                        context,
                        currentGroupe!,
                          DateFormat('yyyy-MM-dd').format(DateTime.now())
                      );
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
                groupe: currentGroupe,
                count: (currentGroupe != null )?getFiltredProfs(context)!
                    .where((element) =>
                        element.groups!.contains(currentGroupe!.id))
                    .toList()
                    .length : 0,
                myData: (currentGroupe != null )?getFiltredProfs(context)!
                    .where((element) =>
                        element.groups!.contains(currentGroupe!.id))
                    .toList(): []
            ),
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
                  tooltip: translation(context).search,
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => const Dialog(
                        child: SearchProfInGroup(),
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
                      setFiltredProfs(
                          profService
                              .getAll()
                              .where((element) =>
                                  element.groups!.contains(currentGroupe!.id))
                              .toList(),
                          context);
                      setAllProfs(profService.getAll(), context);
                    });
                  },
                  tooltip: translation(context).refresh,
                  icon: const Icon(
                    Icons.restart_alt,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                (currentGroupe != null)
                    ? DropdownButton<Groupe>(
                        hint: Text(translation(context).groups),
                        value: (currentGroupe != null)
                            ? currentGroupe
                            : groups!.first,
                        items: groups!.map((Groupe item) {
                          return DropdownMenuItem<Groupe>(
                            value: item,
                            child: Text(item.name!),
                          );
                        }).toList(),
                        onChanged: (Groupe? value) {
                          setState(() {
                            currentGroupe = value;
                            List<Prof> filtredDate = getAllProfs(context)!;
                            filtredDate = filtredDate
                                .where((element) =>
                                    element.groups!.contains(currentGroupe!.id))
                                .toList();
                            setFiltredProfs(filtredDate, context);
                          });
                        },
                      )
                    : const Text('')
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
  var groupe;

  RowSource({
    required this.context,
    required this.myData,
    required this.count,
    required this.groupe,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData[index], groupe, context);
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  DataRow recentFileDataRow(Prof data, Groupe groupe, BuildContext context) {
    return DataRow(cells: [
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: UpdateProf(
                    selectedProf: data,
                    selectedGroup: groupe,
                  ),
              ),
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
                child: UpdateProf(
                  selectedProf: data,
                  selectedGroup: groupe,
                ),
              ),
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
                child: UpdateProf(
                  selectedProf: data,
                  selectedGroup: groupe,
                ),
              ),
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
                  child: UpdateProf(
                    selectedProf: data,
                  )),
            );
          },
          child: Container(
            height: 70,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.1),
              color: (getAmmount(data, groupe,context) <= 0)
                  ? Colors.green.withOpacity(0.9)
                  : Colors.red.withOpacity(0.9),
            ),
            child: (getAmmount(data, groupe,context) != 0)?Text(
              getAmmount(data, groupe, context).abs().toStringAsFixed(2),
              style:
              const TextStyle(fontWeight: FontWeight.w600),
            ) : const Icon(
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
                child: UpdateProf(
                  selectedProf: data,
                  selectedGroup: groupe,
                ),
              ),
            );
          },
          child: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(groupe.profsId!
              .firstWhere(
                  (element) => element.split('?')[0] == data.id.toString())
              .split('?')[1]))),
        ),
      ),
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: UpdateProf(
                  selectedProf: data,
                  selectedGroup: groupe,
                ),
              ),
            );
          },
            child: Text(data.major!),
        ),
      ),
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: UpdateProf(
                  selectedProf: data,
                  selectedGroup: groupe,
                ),
              ),
            );
          },
            child: Text(_getAbsences(data.id!, groupe.id!).toString()),
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
        translation(context).amount_due,
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
        translation(context).major,
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

getData(context, ProfService profService) async {
  List<Prof>? profs = await profService.getAll();
  setAllProfs(profs, context);
  setFiltredProfs(profs, context);
}

List<DateTime> getDates(DateTime startDate, DateTime endDate) {
  List<DateTime> dates = [];

  // Start from the next month with the same day as the start date
  DateTime currentDate =
      DateTime(startDate.year, startDate.month, startDate.day);

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
  DateTime lastDate = DateTime(endDate.year, endDate.month, endDate.day + 1);
  dates.add(lastDate);

  return dates;
}

double getAmmount(Prof prof, Groupe groupe, context) {
  AttendanceService attendanceService = new AttendanceService();
  ProfService profService = new ProfService();
  NotificationService notificationService = new NotificationService();
  double result = 0;
  for (Ammount ammount in prof.dueAmmount!) {
    if (ammount.groupId! == groupe.id) {
      result += ammount.ammount!;
    }
  }
  if (prof.payedAmmount != null) {
    for (Ammount ammount in prof.payedAmmount!) {
      if (ammount.groupId! == groupe.id) {
        result -= ammount.ammount!;
      }
    }
  }
  if (groupe.isRegular! && groupe.profsId!.any((element) => element.split('?').first == prof.id!.toString())) {
    String profInfo = groupe.profsId!.firstWhere(
        ((element) => element.split('?').first == prof.id!.toString()));
    DateTime regDate = DateTime.parse(profInfo.split('?').last);
    List<DateTime> dates = getDates(regDate, groupe.endDate!);
    DateTime firstDate = dates.first;
    dates.remove(firstDate);
    for (DateTime date in dates) {
      if (DateTime.now().isAfter(date)) {
        int absences = attendanceService
            .getAll()
            .where((element) =>
                element.date!.month == date.month &&
                element.date!.year == date.year &&
                element.absentProf!.contains(prof.id!))
            .length;
        if (!prof.dueAmmount!.any((element) =>
            element.date == date && element.groupId == groupe.id)) {
          if (groupe.isProfPaymentRegular!) {
            Ammount ammount = Ammount(
                name: 'due',
                isExpence: false,
                personId: prof.id,
                groupId: groupe.id,
                date: date,
                ammount:
                    groupe.profPrice! - (groupe.absenceAmmount! * absences));
            prof.dueAmmount!.add(ammount);
            result += ammount.ammount!;
            NotificationModel notification = NotificationModel(
                date: DateTime.now(),
                isStudent: false,
                name: '${prof.firstName!} ${prof.lastName!}',
                ammount: ammount.ammount!);
            notificationService.add(notification);
            profService.update(prof);
            getData(context, profService);
          } else {
            int stdNumber = groupe.studentsId!.length;
            Ammount ammount = Ammount(
                name: 'due',
                isExpence: false,
                personId: prof.id,
                groupId: groupe.id,
                date: date,
                ammount: ((stdNumber *
                            groupe.studentPrice! *
                            groupe.profPoucentage!) /
                        100) -
                    (groupe.absenceAmmount! * absences));
            prof.dueAmmount!.add(ammount);
            result += ammount.ammount!;
            NotificationModel notification = NotificationModel(
                date: DateTime.now(),
                isStudent: false,
                name: '${prof.firstName!} ${prof.lastName!}',
                ammount: ammount.ammount!);
            notificationService.add(notification);
            profService.update(prof);
            getData(context, profService);
          }
        }
      }
    }
  }
  return result;
}

int _getAbsences(int prfId, int grpId) {
  AttendanceService attendanceService = new AttendanceService();
  return attendanceService
      .getAll()
      .where((element) =>
          element.absentProf!.contains(prfId) && element.groupId! == grpId)
      .length;
}
