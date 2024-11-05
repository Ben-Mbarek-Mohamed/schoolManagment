import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/providers/profProvider.dart';
import 'package:madrasti/shared/services/profService.dart';

import '../../../language_utils/language_constants.dart';
import '../../../models/group.dart';
import '../../../models/prof.dart';
import '../../services/grouService.dart';

class SearchProf extends StatefulWidget {
  const SearchProf({super.key});

  @override
  State<SearchProf> createState() => _SearchProfState();
}

class _SearchProfState extends State<SearchProf> {
  DateTime? regDate;
  DateTime? birhtDate;
  List<Groupe>? groups = [];
  List<Groupe>? selectedGroups = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();

  GroupService groupService = GroupService();
  ProfService profService = ProfService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.groups = groupService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 500,
      child: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Icon(
            Icons.search,
            color: Colors.blueAccent,
            size: 70,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              controller: _numController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                border: const OutlineInputBorder(),
                labelText: translation(context).reg_number,
                hintText: '1720557910',
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                border: const OutlineInputBorder(),
                labelText: translation(context).name,
                hintText: 'ABC',
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                border: const OutlineInputBorder(),
                labelText: translation(context).last_name,
                hintText: 'ABC',
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              controller: _majorController,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                border: const OutlineInputBorder(),
                labelText: translation(context).major,
                hintText: 'ABC',
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(translation(context).reg_date),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (regDate != picked && picked != null) {
                          setState(() {
                            regDate = picked;
                          });
                        }
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Colors.blueAccent),
                        fixedSize: MaterialStatePropertyAll(Size(150, 40)),
                        elevation: MaterialStatePropertyAll(5),
                      ),
                      child: Text(
                        (regDate == null)
                            ? translation(context).select_date
                            : DateFormat('yyyy-MM-dd').format(regDate!),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 120,
                ),
                Column(
                  children: [
                    Text(translation(context).birth_date),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (birhtDate != picked && picked != null) {
                          setState(() {
                            birhtDate = picked;
                          });
                        }
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Colors.blueAccent),
                        fixedSize: MaterialStatePropertyAll(Size(150, 40)),
                        elevation: MaterialStatePropertyAll(5),
                      ),
                      child: Text(
                        (birhtDate == null)
                            ? translation(context).select_date
                            : DateFormat('yyyy-MM-dd').format(birhtDate!),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: Container(
              height: 55,
              width: 500,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (groups != null) ? groups!.length : 0,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Checkbox(
                        value: selectedGroups!.contains(groups![index]),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              selectedGroups!.add(groups![index]);
                            } else {
                              selectedGroups!.remove(groups![index]);
                            }
                          });
                        },
                      ),
                      Text(groups![index].name!),
                      const SizedBox(width: 20),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        List<Prof> filtredData = profService.getAll();
                        if (_nameController.text.isNotEmpty) {
                          filtredData = await filtredData
                              .where((element) => element.firstName!
                              .toLowerCase()
                              .contains(_nameController.text.toLowerCase()))
                              .toList();
                        }
                        if (_lastNameController.text.isNotEmpty) {
                          filtredData = await filtredData
                              .where((element) => element.lastName!
                              .toLowerCase()
                              .contains(_lastNameController.text.toLowerCase()))
                              .toList();
                        }
                        if (_numController.text.isNotEmpty) {
                          filtredData = await filtredData
                              .where((element) => element.registrationNumber!
                              .toLowerCase()
                              .contains(_numController.text.toLowerCase()))
                              .toList();
                        }
                        if(_majorController.text.isNotEmpty){
                          filtredData = await filtredData
                              .where((element) => element.major!
                              .toLowerCase()
                              .contains(_majorController.text.toLowerCase()))
                              .toList();
                        }
                        if (selectedGroups!.isNotEmpty) {
                          filtredData = await filtredData.where((element) => haveCommonElement(element.groups!, selectedGroups!.map((e) => e.id!).toList())).toList();
                        }
                        if (regDate != null) {
                          filtredData = await filtredData
                              .where((element) =>
                          element.registrationDate.toString() ==
                              regDate.toString())
                              .toList();
                        }
                        if (birhtDate != null) {
                          filtredData = await filtredData
                              .where((element) =>
                          element.birthDate.toString() ==
                              birhtDate.toString())
                              .toList();
                        }
                        setState(() {
                          setFiltredProfs(filtredData, context);
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
                const SizedBox(width: 20),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text(translation(context).cancel, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 20),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),


                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

bool haveCommonElement(List<int> list1, List<int> list2) {
  Set<int> set1 = Set<int>.from(list1);
  print(list1);
  print(list2);
  for (int element in list2) {
    if (set1.contains(element)) {
      return true;
    }
  }

  return false;
}
