import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/models/group.dart';
import 'package:madrasti/providers/ammountProvider.dart';
import 'package:madrasti/providers/expencesProvider.dart';
import 'package:madrasti/shared/services/ammountService.dart';
import 'package:madrasti/shared/services/grouService.dart';
import 'package:madrasti/shared/widgets/add/AddAmmount.dart';
import 'package:madrasti/shared/widgets/search/searchAmmount.dart';
import 'package:madrasti/shared/widgets/update/updateAmmount.dart';
import 'package:provider/provider.dart';

import '../models/ammount.dart';
import '../shared/pdfUtils/generateExpancesPdf.dart';
import '../shared/pdfUtils/generateIncomes.dart';


class ExpencesPage extends StatefulWidget {
  const ExpencesPage({super.key});

  @override
  State<ExpencesPage> createState() => _ExpencesPageState();
}

class _ExpencesPageState extends State<ExpencesPage> {
  AmmountService ammountService = AmmountService();
  GroupService groupService = GroupService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context, ammountService);

  }
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AmmountProvider>(context);
    var provider2 = Provider.of<ExpencesProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: size.width * 0.39,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green,width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(translation(context).incomes,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 25,color: Colors.green),),

                        ],
                      ),
                      PaginatedDataTable(
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
                                        const Dialog(child: AddAmmount(isExpences: false,)),
                                  );

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
                                  generateIncomesPdf(getAllAmmounts(context), context,DateFormat('yyyy-MM-dd').format(DateTime.now()));
                                },
                                tooltip: translation(context).print,
                                icon: const Icon(Icons.print, color: Colors.green,size: 40,),
                              ),
                            ),
                          ],
                          columns: getColumns(context),
                          source: RowSource(context: context, count: getAllAmmounts(context)!.where((element) => element.isExpence == false).toList().length, myData: getAllAmmounts(context)!.where((element) => element.isExpence == false).toList()),
                          rowsPerPage: 7,
                          columnSpacing: 30,
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
                                      child: SearchAmmount(isExpences: false,)
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 30,),
                              IconButton(onPressed: (){
                                getData(context, ammountService);
                              },
                                tooltip: translation(context).refresh,
                                icon: const Icon(
                                Icons.restart_alt,
                                color: Colors.red,
                                size: 40,
                              ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8,),
          Container(
            width: size.width * 0.39,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red,width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                  child: ListView(
                    children: [
                      Text(translation(context).expenses,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 25,color: Colors.red),),
                      PaginatedDataTable(
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
                                        const Dialog(child: AddAmmount(isExpences: true,)),
                                  );

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
                                  generateExpancesPdf(getAllExpences(context),context, DateFormat('yyyy-MM-dd').format(DateTime.now()));
                                },
                                tooltip: translation(context).print,
                                icon: const Icon(Icons.print, color: Colors.green,size: 40,),
                              ),
                            ),
                          ],
                          columns: getColumns(context),
                          source: RowSource(context: context, count: getAllExpences(context)!.length, myData: getAllExpences(context)!),
                          rowsPerPage: 7,
                          columnSpacing: 30,
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
                                        child: SearchAmmount(isExpences: true,)
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 30,),
                              IconButton(onPressed: (){
                                getData(context, ammountService);
                              },
                                tooltip: translation(context).refresh,
                                icon: const Icon(
                                Icons.restart_alt,
                                color: Colors.red,
                                size: 40,
                              ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
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

  DataRow recentFileDataRow(Ammount data, BuildContext context) {

    String groupName = ' _ ';
    if(data.groupId != null) {
      GroupService groupService = GroupService();
      Groupe? groupe = groupService.get(data.groupId!);
      if(groupe != null){
        groupName = groupe.name ?? '';
      }
    }

    return DataRow(cells: [
      DataCell(
        (data.personId.toString().length != 12)?
        GestureDetector(
            onTap: () async {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                    child: UpdateAmmount(
                      selectedAmmount: data,
                    )),
              );
            },
            child: Text((data.personId != null )?'${translation(context).payment_student} ${data.name!}': data.name!)):
        GestureDetector(
            onTap: () async {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                    child: UpdateAmmount(
                      selectedAmmount: data,
                    )),
              );
            },
            child: Text('${translation(context).payment_of_teacher} ${data.name!}')),
      ),
      DataCell(
        GestureDetector(
            onTap: () async {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                    child: UpdateAmmount(
                      selectedAmmount: data,
                    )),
              );
            },
            child: Text(data.ammount.toString())),
      ),
      DataCell(
        GestureDetector(
            onTap: () async {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                    child: UpdateAmmount(
                      selectedAmmount: data,
                    )),
              );
            },
            child: Text(groupName)),
      ),
      DataCell(
        GestureDetector(
            onTap: () async {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                    child: UpdateAmmount(
                      selectedAmmount: data,
                    )),
              );
            },
            child: Text((data.date != null) ? DateFormat('yyyy-MM-dd').format(data.date!) : '')),
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
        translation(context).ammount,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).group,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        translation(context).date,
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

getData(context,AmmountService ammountService) async{
  List<Ammount>? ammounts = await ammountService.getAll().where((element) => element.isExpence == false).toList();
  List<Ammount>? expences = await ammountService.getAll().where((element) => element.isExpence == true).toList();
  setAllAmmounts(ammounts, context);
  setAllExpences(expences, context);
}
