import 'package:flutter/material.dart';
import 'package:madrasti/providers/roomProvider.dart';
import 'package:madrasti/shared/services/grouService.dart';
import 'package:madrasti/shared/services/roomServices.dart';

import '../../../language_utils/language_constants.dart';
import '../../../models/group.dart';
import '../../../models/room.dart';

class UpdateRoom extends StatefulWidget {
  final Room selectedRoom;
  const UpdateRoom({super.key, required this.selectedRoom});

  @override
  State<UpdateRoom> createState() => _UpdateRoomState();
}

class _UpdateRoomState extends State<UpdateRoom> {

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<String> roomDays = [];
  List<Groupe>? groups = [];
  List<Groupe>? grps = [];
  List<Groupe>? selectedGroups = [];

  final TextEditingController _nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  GroupService groupService = GroupService();
  RoomService roomService = RoomService();
  @override
  void initState() {
    // TODO: implement initState
    this.groups = groupService.getAll();
    this.grps = groupService.getAll();
    super.initState();
    startTime = widget.selectedRoom.stratTime;
    endTime = widget.selectedRoom.endTime;
    _nameController.text = widget.selectedRoom.name!;
    var g = widget.selectedRoom.groups!;
    for(String s in g) {
      if(grps!.any((element) => element.name! == s)) {
        Groupe? gr = grps!.firstWhere((element) => element.name! == s);
        if (gr != null) {
          grps!.remove(gr);
          selectedGroups!.add(gr);
        }
      }
    }
    roomDays = widget.selectedRoom.days!;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.6,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translation(context).info,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          roomService.delete(widget.selectedRoom.id!);
                          var filtred = getFiltredRooms(context);
                          filtred!.remove(widget.selectedRoom);
                          setFiltredRooms(context, filtred);
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        translation(context).delete,
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
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
              child: Scrollbar(
                controller: _scrollController,
                trackVisibility: true,
                thumbVisibility: true,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
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
            const SizedBox(
              height: 30,
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
                      width: 20,
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
                      width: 20,
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
                      width: 20,
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
                      width: 20,
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
                      width: 20,
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
                      width: 20,
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
                        if (_nameController.text.isNotEmpty &&
                            startTime != null &&
                            endTime != null &&
                            selectedGroups!.isNotEmpty &&
                            roomDays.isNotEmpty) {

                          Room room = Room(
                            id: widget.selectedRoom.id,
                              groups: selectedGroups!.map((e) => e.name!).toList() ,
                              name: _nameController.text,
                              days: roomDays,
                              stratTime: startTime,
                              endTime: endTime
                          );
                          roomService.update(room);
                          setState(() {
                            setAllRooms(context,roomService.getAll());
                            setFiltredRooms(context,roomService.getAll());
                          });
                          Navigator.of(context).pop();
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                Future.delayed(const Duration(seconds: 3), () {
                                  Navigator.of(context).pop();
                                });
                                return Dialog(
                                  elevation: 2,
                                  backgroundColor: Colors.red.withOpacity(0.5),
                                  child: Container(
                                    height: 60,
                                    width: 400,
                                    child: Center(
                                      child: Text(
                                        translation(context).error_message,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                      child: Text(
                        translation(context).save,
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w600,fontSize: 20),
                      ),
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
                      child: Text(
                        translation(context).cancel,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w600,fontSize: 20),
                      ),
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
