import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/providers/roomProvider.dart';
import 'package:madrasti/shared/services/roomServices.dart';
import 'package:madrasti/shared/widgets/add/addRoom.dart';
import 'package:madrasti/shared/widgets/search/searchRoom.dart';
import 'package:madrasti/shared/widgets/update/updateRoom.dart';
import 'package:provider/provider.dart';

import '../language_utils/language_constants.dart';
import '../models/room.dart';
import '../shared/pdfUtils/generateRoomList.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  RoomService roomService = new RoomService();

  @override
  void initState() {
    // TODO: implement initState
    getData(context, roomService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<RoomProvider>(context);
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
                        builder: (BuildContext context) =>
                            const Dialog(child: AddRoom()),
                      );
                      // setState(() {
                      //   allGroups = groupService.getAll();
                      // });
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
                      generateRoomsPdf(getFiltredRooms(context),context, DateFormat('yyyy-MM-dd').format(DateTime.now()));
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
                  count: getFiltredRooms(context)!.length,
                  myData: getFiltredRooms(context)),
              rowsPerPage: 8,
              columnSpacing: 50,
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
                          child: SizedBox(
                            width: 700,
                            child: SearchRoom(),
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
                      setFiltredRooms(context, roomService.getAll());
                    },
                    tooltip: translation(context).refresh,
                    icon: const Icon(
                      Icons.restart_alt,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              )),
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

  DataRow recentFileDataRow(Room data, BuildContext context) {
    String sessiondays = '';
    for (String day in data.days!) {
      if (day == 'monday') {
        sessiondays = sessiondays + translation(context).monday + ' ,';
      }
      if (day == 'tuesday') {
        sessiondays = sessiondays + translation(context).tuesday + ' ,';
      }
      if (day == 'wednesday') {
        sessiondays = sessiondays + translation(context).wednesday + ' ,';
      }
      if (day == 'thursday') {
        sessiondays = sessiondays + translation(context).thursday + ' ,';
      }
      if (day == 'friday') {
        sessiondays = sessiondays + translation(context).friday + ' ,';
      }
      if (day == 'saturday') {
        sessiondays = sessiondays + translation(context).saturday + ' ,';
      }
      if (day == 'sunday') {
        sessiondays = sessiondays + translation(context).sunday + ' ,';
      }
    }
    String groups = '';
    for (String group in data.groups!) {
      groups = groups + group + ' ,';
    }
    return DataRow(cells: [
      DataCell(
        GestureDetector(
            onTap: () async {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                    child: UpdateRoom(
                  selectedRoom: data,
                )),
              );
            },
            child: Text(data.name.toString())),
      ),
      DataCell(
        GestureDetector(
            onTap: () async {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                    child: UpdateRoom(
                  selectedRoom: data,
                )),
              );
            },
            child: Text((groups.length > 2)?groups.substring(0, groups.length - 1) :'' )),
      ),
      DataCell(
        GestureDetector(
            onTap: () async {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                    child: UpdateRoom(
                  selectedRoom: data,
                )),
              );
            },
            child: Text(sessiondays.substring(0, sessiondays.length - 1))),
      ),
      DataCell(
        GestureDetector(
          onTap: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                  child: UpdateRoom(
                    selectedRoom: data,
                  )),
            );
          },
          child: Text(data.stratTime!.format(context) +
              '  -  ' +
              data.endTime!.format(context)),
        ),
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
        translation(context).groups,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).reserved_days,
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

getData(context, RoomService roomService) async {
  List<Room>? rooms = await roomService.getAll();
  setFiltredRooms(context, rooms);
  setAllRooms(context, rooms);
}
