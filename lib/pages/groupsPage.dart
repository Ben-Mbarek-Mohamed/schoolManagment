import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/providers/groupProvider.dart';
import 'package:madrasti/shared/services/grouService.dart';
import 'package:madrasti/shared/widgets/add/addGroup.dart';
import 'package:madrasti/shared/widgets/update/updateGroup.dart';
import 'package:provider/provider.dart';

import '../language_utils/language_constants.dart';
import '../models/group.dart';
import '../shared/pdfUtils/generateGroupList.dart';
import '../shared/widgets/search/searchGroup.dart';

class GroupePage extends StatefulWidget {
  const GroupePage({super.key});

  @override
  State<GroupePage> createState() => _GroupePageState();
}

class _GroupePageState extends State<GroupePage> {
  GroupService groupService = GroupService();

  @override
  void initState() {
    // TODO: implement initState
    getData(context, groupService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);
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
                            const Dialog(child: AddGroup()),
                      );
                      // setState(() {
                      //   allGroups = groupService.getAll();
                      // });
                    },
                    tooltip: translation(context).add,
                    icon: const Icon(Icons.add_circle, color: Colors.blueAccent,size: 40,),
                  ),
                ),
                const SizedBox(width: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      if(getFiltredGroups(context) != null) {
                        generateGroupsPdf(getFiltredGroups(context),context, DateFormat('yyyy-MM-dd').format(DateTime.now()) );
                      }
                    },
                    tooltip: translation(context).print,
                    icon: const Icon(Icons.print, color: Colors.green,size: 40,),
                  ),
                ),
              ],
              columns: getColumns(context),
              source: RowSource(
                  context: context, count: getFiltredGroups(context)!.length, myData: getFiltredGroups(context)),
              rowsPerPage: 8,
              columnSpacing: 40,
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
                            width: 700,
                            child: const SerchGroup(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 30,),
                  IconButton(
                    onPressed: (){setFiltredGroups(context, groupService.getAll());},
                    tooltip: translation(context).refresh,
                    icon: const Icon(
                    Icons.restart_alt,
                    color: Colors.red,
                    size: 40,
                  ),
                  ),
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

  DataRow recentFileDataRow(Groupe data, BuildContext context) {
    String sessiondays = '';
    for (String day in data.sessionDays!.map((e) => e.day!)) {
      if (day == 'monday') {
        sessiondays = '$sessiondays${translation(context).monday} ,';
      }
      if (day == 'tuesday') {
        sessiondays = '$sessiondays${translation(context).tuesday} ,';
      }
      if (day == 'wednesday') {
        sessiondays = '$sessiondays${translation(context).wednesday} ,';
      }
      if (day == 'thursday') {
        sessiondays = '$sessiondays${translation(context).thursday} ,';
      }
      if (day == 'friday') {
        sessiondays = '$sessiondays${translation(context).friday} ,';
      }
      if (day == 'saturday') {
        sessiondays = '$sessiondays${translation(context).saturday} ,';
      }
      if (day == 'sunday') {
        sessiondays = '$sessiondays${translation(context).sunday} ,';
      }
    }
    return DataRow(cells: [
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: UpdateGroup(
                    selectedGroup: data,
                  )),
            );
          },
            child: Text((data.name != null) ? data.name! : ''),
        ),
      ),
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: UpdateGroup(
                    selectedGroup: data,
                  )),
            );
          },
          child: Text((data.isRegular!)
              ? translation(context).regular
              : translation(context).session),
        ),
      ),
      DataCell(
        GestureDetector(onTap: () async {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
                child: UpdateGroup(
                  selectedGroup: data,
                )),
          );
        },child: Text((data.startDate != null) ? DateFormat('yyyy-MM-dd').format(data.startDate!) : '')),
      ),
      DataCell(
        GestureDetector(onTap: () async {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
                child: UpdateGroup(
                  selectedGroup: data,
                )),
          );
        },child: Text((data.endDate != null) ? DateFormat('yyyy-MM-dd').format(data.endDate!) : '')),
      ),
      DataCell(
        GestureDetector(onTap: () async {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
                child: UpdateGroup(
                  selectedGroup: data,
                )),
          );
        },child: Text(data.studentsId!.length.toString())),
      ),
      DataCell(
        //Text(data.profId!.length.toString()),
        GestureDetector(onTap: () async {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
                child: UpdateGroup(
                  selectedGroup: data,
                )),
          );
        },child: Text(data.profsId!.length.toString())),
      ),
      DataCell(
        GestureDetector(onTap: () async {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
                child: UpdateGroup(
                  selectedGroup: data,
                )),
          );
        },child: Container(width: 190, child: Text(sessiondays.substring(0, sessiondays.length - 1)))),
      ),
      DataCell(
        //data.stratTime!.format(context) + '  -  ' +data.endTime!.format(context)
      (data.sessionDays!.first.startTime !=null)?Text('${data.sessionDays!.first.startTime!.format(context)}  -  ${data.sessionDays!.first.endTime!.format(context)}'):const Text(''),
      ),
    ]);
  }
}

List<DataColumn> getColumns(context) {
  return [
    DataColumn(
      label: Text(
        translation(context).name,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).system,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).start_date,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).end_date,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).students_number,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).teachers_number,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).class_days,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).time,
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

getData(context,GroupService groupService) async{
  List<Groupe>? groups = await groupService.getAll();
  setAllGroups(context, groups);
  setFiltredGroups(context, groups);
}