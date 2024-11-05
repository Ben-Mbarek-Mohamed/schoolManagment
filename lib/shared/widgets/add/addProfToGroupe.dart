import 'package:flutter/material.dart';
import 'package:madrasti/providers/profProvider.dart';
import 'package:madrasti/shared/services/profService.dart';
import 'package:provider/provider.dart';

import '../../../language_utils/language_constants.dart';
import '../../../models/group.dart';
import '../../../models/prof.dart';
import '../../../providers/groupProvider.dart';
import '../../services/grouService.dart';

class AddProfToGroupe extends StatefulWidget {
  final Groupe? groupe;
  const AddProfToGroupe({super.key,required this.groupe});

  @override
  State<AddProfToGroupe> createState() => _AddProfToGroupeState();
}

class _AddProfToGroupeState extends State<AddProfToGroupe> {
  ProfService profService = ProfService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context, profService);
  }
  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<ProfProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 700,
      child: PaginatedDataTable(

        showFirstLastButtons: true,
        arrowHeadColor: Colors.blueAccent,
        actions: [

        ],
        columns: getColumns(context),
        source: RowSource(context: context, count: getFiltredProfs(context)!.length, myData: getFiltredProfs(context)!,groupe: widget.groupe),
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
                    child: SizedBox(),
                  ),
                );
              },
            ),
            const SizedBox(width: 30,),
            IconButton(onPressed: (){
              setState(() {
                setFiltredProfs(profService.getAll(), context);
                setAllProfs(profService.getAll(), context);
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

  DataRow recentFileDataRow(Prof data, BuildContext context,Groupe? groupe) {
    ProfService profService = new ProfService();
    GroupService groupService = new GroupService();
    return DataRow(cells: [
      DataCell(
        GestureDetector(
          onTap: (){
            if(groupe != null){
              if(groupe.profsId!.map((e) => e.split('?').first).toList().contains(data.id.toString())){
                Navigator.of(context).pop();
              }
              else{
                Groupe gr = groupe;
                gr.profsId!.add('${data.id!}?${DateTime.now()}');
                groupService.update(gr);
                Prof prf = data;
                prf.groups!.add(gr.id!);
                profService.update(prf);
                setFiltredProfs(profService.getAll(), context);
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
              if(groupe.profsId!.map((e) => e.split('?').first).toList().contains(data.id.toString())){
                Navigator.of(context).pop();
              }
              else{
                Groupe gr = groupe;
                gr.profsId!.add('${data.id!}?${DateTime.now()}');
                groupService.update(gr);
                Prof prf = data;
                prf.groups!.add(gr.id!);
                profService.update(prf);
                setFiltredProfs(profService.getAll(), context);
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
              if(groupe.profsId!.map((e) => e.split('?').first).toList().contains(data.id.toString())){
                Navigator.of(context).pop();
              }
              else{
                Groupe gr = groupe;
                gr.profsId!.add('${data.id!}?${DateTime.now()}');
                groupService.update(gr);
                Prof prf = data;
                prf.groups!.add(gr.id!);
                profService.update(prf);
                setFiltredProfs(profService.getAll(), context);
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


getData(context,ProfService profService) async{
  List<Prof>? profs = await profService.getAll();
  setAllProfs(profs, context);
  setFiltredProfs(profs, context);
}
