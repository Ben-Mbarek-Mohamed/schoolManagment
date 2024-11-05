import 'package:flutter/material.dart';
import 'package:madrasti/providers/roomProvider.dart';
import 'package:madrasti/shared/services/grouService.dart';
import 'package:madrasti/shared/services/roomServices.dart';
import 'package:provider/provider.dart';

import '../../../language_utils/language_constants.dart';
import '../../../models/group.dart';
import '../../../models/room.dart';

class SearchRoom extends StatefulWidget {
  const SearchRoom({super.key});

  @override
  State<SearchRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<SearchRoom> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<String> roomDays = [];
  List<Groupe>? groups = [];
  List<Groupe>? selectedGroups = [];

  final TextEditingController _nameController = TextEditingController();

  GroupService groupService = GroupService();
  RoomService roomService = RoomService();
  @override
  void initState() {
    // TODO: implement initState
    groups = groupService.getAll();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<RoomProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
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
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                  border: const OutlineInputBorder(),
                  labelText: translation(context).name,
                  hintText: translation(context).room + ' 1',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Text(translation(context).start_time),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: startTime ?? TimeOfDay.now(),
                        );
                        if (startTime != picked && picked != null) {
                          setState(() {
                            startTime = picked;
                          });
                        }
                      },
                      child: Text(
                        (startTime == null)
                            ? translation(context).start_time
                            : startTime!.format(context),
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Colors.blueAccent),
                        fixedSize: MaterialStatePropertyAll(Size(150, 40)),
                        elevation: MaterialStatePropertyAll(5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 270,
                ),
                Column(
                  children: [
                    Text(translation(context).end_time),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: startTime ?? TimeOfDay.now(),
                        );
                        if (endTime != picked && picked != null) {
                          setState(() {
                            endTime = picked;
                          });
                        }
                      },
                      child: Text(
                        (endTime == null)
                            ? translation(context).end_time
                            : endTime!.format(context),
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Colors.blueAccent),
                        fixedSize: MaterialStatePropertyAll(Size(150, 40)),
                        elevation: MaterialStatePropertyAll(5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            Text(
              translation(context).groups + ' :',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            Container(
              height: 100,
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
            const SizedBox(
              height: 30,
            ),
            Text('${translation(context).reserved_days} :'),
            const SizedBox(height: 20,),
            Row(
              children: [

                const SizedBox(
                  width: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            value: roomDays.contains('monday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  roomDays.add('monday');
                                } else {
                                  roomDays.remove('monday');
                                }
                              });
                            }),
                        Text(translation(context).monday),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: roomDays.contains('tuesday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  roomDays.add('tuesday');
                                } else {
                                  roomDays.remove('tuesday');
                                }
                              });
                            }),
                        Text(translation(context).tuesday),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: roomDays.contains('wednesday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  roomDays.add('wednesday');
                                } else {
                                  roomDays.remove('wednesday');
                                }
                              });
                            }),
                        Text(translation(context).wednesday),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: roomDays.contains('thursday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  roomDays.add('thursday');
                                } else {
                                  roomDays.remove('thursday');
                                }
                              });
                            }),
                        Text(translation(context).thursday),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: roomDays.contains('friday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  roomDays.add('friday');
                                } else {
                                  roomDays.remove('friday');
                                }
                              });
                            }),
                        Text(translation(context).friday),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: roomDays.contains('saturday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  roomDays.add('saturday');
                                } else {
                                  roomDays.remove('saturday');
                                }
                              });
                            }),
                        Text(translation(context).saturday),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: roomDays.contains('sunday'),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  roomDays.add('sunday');
                                } else {
                                  roomDays.remove('sunday');
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
            const SizedBox(height: 50),
            Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if(_nameController.text.isNotEmpty){
                          List<Room>? filtredData = getFiltredRooms(context);
                          filtredData = filtredData!.where((element) => element.name!.toLowerCase().contains(_nameController.text.toLowerCase())).toList();
                          setFiltredRooms(context, filtredData);
                        }
                        if(selectedGroups!.isNotEmpty){
                          List<Room>? filtredData = getFiltredRooms(context);
                          filtredData = filtredData!.where((element) => haveCommonElement(element.groups!, selectedGroups!.map((e) => e.name!).toList())).toList();
                          setFiltredRooms(context, filtredData);
                        }
                        if(startTime != null){
                          List<Room>? filtredData = getFiltredRooms(context);
                          filtredData = filtredData!.where((element) => element.stratTime == startTime).toList();
                          setFiltredRooms(context, filtredData);
                        }
                        if(endTime != null){
                          List<Room>? filtredData = getFiltredRooms(context);
                          filtredData = filtredData!.where((element) => element.endTime == endTime).toList();
                          setFiltredRooms(context, filtredData);
                        }
                        if(roomDays!.isNotEmpty){
                          List<Room>? filtredData = getFiltredRooms(context);
                          filtredData = filtredData!.where((element) => haveCommonElement(element.days!, roomDays)).toList();
                          setFiltredRooms(context, filtredData);
                        }
                        Navigator.of(context).pop();
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
          ],
        ),
      ),
    );
  }
}
bool haveCommonElement(List<String> list1, List<String> list2) {
  Set<String> set1 = Set<String>.from(list1);
  for (String element in list2) {
    if (set1.contains(element)) {
      return true;
    }
  }

  return false;
}