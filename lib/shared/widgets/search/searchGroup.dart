import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madrasti/models/group.dart';
import 'package:madrasti/models/sessionTime.dart';
import 'package:madrasti/shared/services/grouService.dart';
import 'package:provider/provider.dart';

import '../../../language_utils/language_constants.dart';
import '../../../providers/groupProvider.dart';

class SerchGroup extends StatefulWidget {
  const SerchGroup({super.key});

  @override
  State<SerchGroup> createState() => _SerchGroupState();
}

class _SerchGroupState extends State<SerchGroup> {
  GroupService groupService = GroupService();
  List<String> groupDays = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentController = TextEditingController();
  final TextEditingController _ammountController = TextEditingController();
  final TextEditingController _profController = TextEditingController();
  final TextEditingController _studentNumberController = TextEditingController();
  final TextEditingController _profNumberController = TextEditingController();
  bool isRegular = false;
  bool isSession = false;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);
    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Icon(
          Icons.search,
          color: Colors.blueAccent,
          size: 70,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent)),
              border: const OutlineInputBorder(),
              labelText: translation(context).name,
              hintText: 'abc',
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(
              width: 40,
            ),
            Text(
              translation(context).system + ' :',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              width: 150,
              child: CheckboxListTile(
                value: isRegular,
                onChanged: (val) {
                  setState(() {
                    isRegular = val ?? false;
                    print('isRegular: $isRegular');
                    if (isRegular == true) {
                      isSession = false;
                    }
                  });
                },
                title: Text(translation(context).regular),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            Container(
              width: 150,
              child: CheckboxListTile(
                value: isSession,
                onChanged: (val) {
                  setState(() {
                    isSession = val ?? false;
                    print('isSession: $isSession');
                    if (isSession == true) {
                      isRegular = false;
                    }
                  });
                },
                title: Text(translation(context).session),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: TextFormField(
            controller: _studentController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent)),
              border: const OutlineInputBorder(),
              labelText: translation(context).price_per_student,
              hintText: '1000',
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: TextFormField(
            controller: _ammountController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent)),
              border: const OutlineInputBorder(),
              labelText: translation(context).absence_ammount,
              hintText: '1000',
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: TextFormField(
            controller: _profController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent)),
              border: const OutlineInputBorder(),
              labelText: translation(context).price_per_teacher,
              hintText: '1000',
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: TextFormField(
            controller: _studentNumberController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent)),
              border: const OutlineInputBorder(),
              labelText: translation(context).students_number,
              hintText: '10',
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: TextFormField(
            controller: _profNumberController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent)),
              border: const OutlineInputBorder(),
              labelText: translation(context).teachers_number,
              hintText: '10',
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Column(
          children: [
            Text(
              translation(context).class_days + ' :',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                translation(context).number_of_sessions +
                    ' : ' +
                    groupDays.length.toString(),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            value: groupDays.contains('monday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  groupDays.add('monday');
                                } else {
                                  groupDays.remove('monday');
                                }
                              });
                            }),
                        Text(translation(context).monday),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: groupDays.contains('tuesday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  groupDays.add('tuesday');
                                } else {
                                  groupDays.remove('tuesday');
                                }
                              });
                            }),
                        Text(translation(context).tuesday),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: groupDays.contains('wednesday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  groupDays.add('wednesday');
                                } else {
                                  groupDays.remove('wednesday');
                                }
                              });
                            }),
                        Text(translation(context).wednesday),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: groupDays.contains('thursday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  groupDays.add('thursday');
                                } else {
                                  groupDays.remove('thursday');
                                }
                              });
                            }),
                        Text(translation(context).thursday),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: groupDays.contains('friday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  groupDays.add('friday');
                                } else {
                                  groupDays.remove('friday');
                                }
                              });
                            }),
                        Text(translation(context).friday),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: groupDays.contains('saturday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  groupDays.add('saturday');
                                } else {
                                  groupDays.remove('saturday');
                                }
                              });
                            }),
                        Text(translation(context).saturday),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: groupDays.contains('sunday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  groupDays.add('sunday');
                                } else {
                                  groupDays.remove('sunday');
                                }
                              });
                            }),
                        Text(translation(context).sunday),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        List<Groupe>? filtredDate = groupService.getAll();
                        Groupe gr = Groupe(
                          name: _nameController.text,
                          studentPrice: double.tryParse(_studentController.text),
                          profPrice: double.tryParse(_profController.text),
                          absenceAmmount: double.tryParse(_ammountController.text),
                          sessionDays: groupDays.map((e) => SessionTime(day: e)).toList(),
                          isRegular: isRegular,
                          // studentsId: [int.parse(_studentNumberController.text)],
                          // profId: [int.parse(_profNumberController.text)]
                        );

                          for(Groupe g in filtredDate){
                            if (gr.name != null && g.name!.toLowerCase().contains(gr.name!.toLowerCase()) && gr.name != null){
                              filtredDate = await filtredDate!.where((element) => element.name!.toLowerCase().contains(gr.name!.toLowerCase())).toList();
                            }
                            if(isRegular == true || isSession == true){
                              if(g.isRegular == gr.isRegular){
                                filtredDate = await filtredDate!.where((element) => element.isRegular == gr.isRegular).toList();
                              }
                            }
                            if(gr.studentPrice != null && g.studentPrice == gr.studentPrice){
                              filtredDate = await filtredDate!.where((element) => element.studentPrice == gr.studentPrice).toList();
                            }
                            if(gr.absenceAmmount != null && g.absenceAmmount == gr.absenceAmmount){
                              filtredDate = await filtredDate!.where((element) => element.absenceAmmount == gr.absenceAmmount).toList();
                            }
                            if(gr.profPrice != null ){
                              filtredDate = await filtredDate!.where((element) => element.profPrice == gr.profPrice || gr.profPrice == g.profPoucentage).toList();
                            }
                            if(_studentNumberController.text.isNotEmpty ){
                                filtredDate = await filtredDate!.where((element) => element.studentsId!.length == int.parse(_studentNumberController.text)).toList();
                            }
                            if(_profNumberController.text.isNotEmpty ){
                              filtredDate = await filtredDate!.where((element) => element.profsId!.length == int.parse(_profNumberController.text)).toList();
                            }
                            if(groupDays.isNotEmpty){
                              filtredDate = await filtredDate!.where((element) => haveCommonElement(element.sessionDays!, groupDays!)).toList();
                            }
                          }
                        setFiltredGroups(context, filtredDate);
                          print(gr.name);
                        print(filtredDate!.length);
                          print(getFiltredGroups(context)!.length);
                          setState(() {
                            Navigator.of(context).pop();
                          });

                      },
                      child: Text(translation(context).save, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 20),),

                  ),
                  const SizedBox(
                    height: 10,
                  ),

                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: Text(translation(context).cancel, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 20),),

                  ),
                  const SizedBox(
                    height: 10,
                  ),

                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}


bool haveCommonElement(List<SessionTime> list1, List<String> list2) {
  Set<String> set1 = Set<String>.from(list2);
  for (SessionTime element in list1) {
    if (set1.contains(element.day)) {
      return true;
    }
  }
  return false;
}