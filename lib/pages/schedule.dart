import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/models/schedule.dart';
import 'package:madrasti/shared/services/secheduleService.dart';

import '../models/lesson.dart';
import '../shared/pdfUtils/ganerateSchedule.dart';

class ScheduleTable extends StatefulWidget {
  @override
  _ScheduleTableState createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {

  List<Schedule> schedules = [];
  Schedule? currentSchedule ;
  List<String> timeSlots = [
    "08:00 - 09:00",
    "09:00 - 10:00",
    "10:00 - 11:00",
    "11:00 - 12:00",
    "12:00 - 13:00",
    "13:00 - 14:00",
    "14:00 - 15:00",
    "15:00 - 16:00",
    "16:00 - 17:00",
    "17:00 - 18:00",
    "18:00 - 19:00",
    "19:00 - 20:00",
    "20:00 - 21:00"
  ];

  int _getTimeSlotIndex(TimeOfDay time) {
    for (int i = 0; i < timeSlots.length; i++) {
      try {
        final timeRange = timeSlots[i].split(' - ');

        if (timeRange.length != 2) {
          continue;
        }

        final startTimeParts = timeRange[0].trim().split(':');
        final endTimeParts = timeRange[1].trim().split(':');

        if (startTimeParts.length != 2 || endTimeParts.length != 2) {
          continue;
        }

        final startHour = int.tryParse(startTimeParts[0]) ?? 0;
        final startMinute = int.tryParse(startTimeParts[1]) ?? 0;
        final endHour = int.tryParse(endTimeParts[0]) ?? 0;
        final endMinute = int.tryParse(endTimeParts[1]) ?? 0;

        final startTime = TimeOfDay(hour: startHour, minute: startMinute);
        final endTime = TimeOfDay(hour: endHour, minute: endMinute);

        if ((time.hour > startTime.hour ||
                (time.hour == startTime.hour &&
                    time.minute >= startTime.minute)) &&
            (time.hour < endTime.hour ||
                (time.hour == endTime.hour && time.minute <= endTime.minute))) {
          return i;
        }
      } catch (e) {
      }
    }
    return -1; // Not found
  }
  ScheduleService scheduleService = new ScheduleService();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<Schedule> sc = scheduleService.getAll();
    if(sc == null || sc.isEmpty){
      Schedule schedule = Schedule(
        lessons: [],
        date: DateTime.now(),
        name: '',
        id: 0
      );
      scheduleService.add(schedule);
      setState(() {
        schedules = scheduleService.getAll();
        currentSchedule = schedules.first;
      });
    }
    else{
      schedules = scheduleService.getAll();
      currentSchedule = schedules.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> days = [
      translation(context).monday,
      translation(context).tuesday,
      translation(context).wednesday,
      translation(context).thursday,
      translation(context).friday,
      translation(context).saturday,
      translation(context).sunday
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (schedules.isNotEmpty)?DropdownButton<Schedule>(
                hint: Text(translation(context).groups),
                value: (currentSchedule != null)
                    ? currentSchedule
                    : schedules.first,
                items: schedules.map((Schedule item) {
                  return DropdownMenuItem<Schedule>(
                    value: item,
                    child: Text((item.name != '')?item.name! : translation(context).schedule + '(${DateFormat('yyyy-MM-dd').format(item.date!)})'),
                  );
                }).toList(),
                onChanged: (Schedule? value) {
                  setState(() {
                    currentSchedule = value;
                  });
                },
              ):const SizedBox(),
            ),
            const SizedBox(width: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if(schedules.length > 1 && currentSchedule != null){

                    setState(() {
                      scheduleService.delete(currentSchedule!.id!);
                      schedules.remove(currentSchedule);
                      currentSchedule = schedules.first;
                    });
                  }
                },
                style:  ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.redAccent.withOpacity(0.8)),
                  fixedSize: const MaterialStatePropertyAll(Size(180, 40)),
                  elevation: const MaterialStatePropertyAll(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(translation(context).delete_schedule),
                    const Icon(Icons.delete_forever_outlined),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  String name = '';
                  bool isOk = await showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Container(
                      height: 270,
                      width: 400,
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15,),
                          Text(translation(context).add +' '+ translation(context).schedule, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                          const SizedBox(height: 15,),
                          TextFormField(
                            onChanged: (value) {
                              name = value;
                            },
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueAccent)),
                              border: const OutlineInputBorder(),
                              labelText: translation(context).name,
                              hintText: '',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      Schedule sc = Schedule(
                                        name: name,
                                        date: DateTime.now(),
                                        lessons: [],
                                        id: 0
                                      );
                                      Schedule sched = await scheduleService.add(sc);
                                      setState(() {
                                        currentSchedule = sched;
                                        schedules.add(sched);
                                      });
                                     Navigator.of(context).pop(true);
                                    },
                                    icon: const Icon(
                                      Icons.done,
                                      color: Colors.green,
                                      size: 35,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(translation(context).save, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),)
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 35,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(translation(context).cancel, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),)
                                ],
                              ),
                            ],
                          ),

                        ],
                      )
                    ),
                  ),
                  );
                },
                style:  ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.deepPurpleAccent.withOpacity(0.8)),
                  fixedSize: const MaterialStatePropertyAll(Size(155, 40)),
                  elevation: const MaterialStatePropertyAll(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(translation(context).add +' '+ translation(context).schedule),
                    const Icon(Icons.add),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _addOrEditLesson,
                style:  ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blueAccent.withOpacity(0.8)),
                  fixedSize: const MaterialStatePropertyAll(Size(155, 40)),
                  elevation: const MaterialStatePropertyAll(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(translation(context).add_lesson),
                    const Icon(Icons.add)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if(currentSchedule != null && currentSchedule!.lessons != null) {
                    generateSchedulePdf(
                      currentSchedule!.lessons!,
                      context,
                    );
                  }
                },
                style:  ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green.withOpacity(0.8)),
                  fixedSize: const MaterialStatePropertyAll(Size(125, 40)),
                  elevation: const MaterialStatePropertyAll(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(translation(context).print),
                    const Icon(Icons.print)
                  ],
                ),
              ),
            ),

          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(),
              defaultColumnWidth: const FixedColumnWidth(90.0),
              children: [
                // Header Row with Time Slots
                TableRow(
                  children: [
                    TableCell(child: Container()), // Empty top-left cell
                    ...timeSlots
                        .map((time) => Center(child: Text(time)))
                        .toList(),
                  ],
                ),
                // Days with corresponding Lessons
                ...days.map((day) {
                  return TableRow(
                    children: [
                      Center(child: Text(day)), // Day column
                      ...timeSlots.map((time) {
                        // Determine the lessons for this cell
                        List<Lesson> cellLessons = currentSchedule!.lessons!
                            .where((lesson) =>
                                lesson.day == day &&
                                _isTimeWithinLesson(time, lesson))
                            .toList();

                        return _buildLessonCell(time, cellLessons, day);
                      }).toList(),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _isTimeWithinLesson(String time, Lesson lesson) {
    try {
      TimeOfDay cellTime = TimeOfDay(
        hour: int.parse(time.split(' - ')[0].split(':')[0]),
        minute: int.parse(time.split(' - ')[0].split(':')[1]),
      );

      return (cellTime.hour > lesson.startTime.hour ||
              (cellTime.hour == lesson.startTime.hour &&
                  cellTime.minute >= lesson.startTime.minute)) &&
          (cellTime.hour < lesson.endTime.hour ||
              (cellTime.hour == lesson.endTime.hour &&
                  cellTime.minute <= lesson.endTime.minute));
    } catch (e) {
      print('Error parsing time or lesson: $e');
      return false;
    }
  }

  Widget _buildLessonCell(String time, List<Lesson> cellLessons, String day) {
    try {
      TimeOfDay cellTime = TimeOfDay(
        hour: int.parse(time.split(' - ')[0].split(':')[0]),
        minute: int.parse(time.split(' - ')[0].split(':')[1]),
      );

      int cellIndex = _getTimeSlotIndex(cellTime);

      List<Widget> lessonWidgets = [];

      for (Lesson lesson in cellLessons) {
        int startIndex = _getTimeSlotIndex(lesson.startTime);
        int endIndex = _getTimeSlotIndex(lesson.endTime);

        bool coversCell = startIndex <= cellIndex && cellIndex < endIndex;

        if (coversCell) {
          lessonWidgets.add(Container(
            height: 50,
            color: lesson.color.withOpacity(0.7),
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                lesson.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ));
        }
      }

      return lessonWidgets.isEmpty
          ? Container(height: 50, color: Colors.white)
          : Stack(
              children: lessonWidgets,
            );
    } catch (e) {
      print('Error building lesson cell: $e');
      return Container(height: 50, color: Colors.red); // Error state
    }
  }

  void _addOrEditLesson() async {
    String? selectedDay;
    TimeOfDay? selectedStartTime;
    TimeOfDay? selectedEndTime;
    String lessonName = '';
    Color selectedColor = Colors.blue;
    List<String> days = [
      translation(context).monday,
      translation(context).tuesday,
      translation(context).wednesday,
      translation(context).thursday,
      translation(context).friday,
      translation(context).saturday,
      translation(context).sunday
    ];
    Lesson? newLesson = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translation(context).add_lesson),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        lessonName = value;
                      },
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent)),
                        border: const OutlineInputBorder(),
                        labelText: translation(context).name,
                        hintText: 'math',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButton<String>(
                      value: selectedDay,
                      hint: Text(translation(context).day),
                      items: days.map((day) {
                        return DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDay = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                selectedStartTime = TimeOfDay(hour: pickedTime.hour, minute: 0);
                              });
                            }
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blueAccent),
                            fixedSize: MaterialStatePropertyAll(Size(150, 40)),
                            elevation: MaterialStatePropertyAll(5),
                          ),
                          child: Text(selectedStartTime != null
                              ? selectedStartTime!.format(context)
                              : translation(context).start_time),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                selectedEndTime = TimeOfDay(hour: pickedTime.hour, minute: 0);
                              });
                            }
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blueAccent),
                            fixedSize: MaterialStatePropertyAll(Size(150, 40)),
                            elevation: MaterialStatePropertyAll(5),
                          ),
                          child: Text(selectedEndTime != null
                              ? selectedEndTime!.format(context)
                              : translation(context).end_time),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 130,
                      child: ListTile(
                        title: Text(translation(context).color),
                        trailing: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: selectedColor,
                          ),
                        ),
                        onTap: () async {
                          Color? color = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ColorPickerDialog(
                                initialColor: selectedColor,
                              );
                            },
                          );
                          if (color != null) {
                            setState(() {
                              selectedColor = color;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (selectedDay != null &&
                                    selectedStartTime != null &&
                                    selectedEndTime != null) {
                                  Navigator.of(context).pop(
                                    Lesson(
                                      name: lessonName,
                                      color: selectedColor,
                                      startTime: selectedStartTime!,
                                      endTime: selectedEndTime!,
                                      day: selectedDay!,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                                size: 35,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              translation(context).save,
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 35,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(translation(context).cancel,
                                style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (newLesson != null) {
      setState(() {
        currentSchedule!.lessons!.add(newLesson);
        scheduleService.update(currentSchedule!);
      });
    }
  }
}

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  ColorPickerDialog({required this.initialColor});

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color? pickedColor;

  @override
  void initState() {
    super.initState();
    pickedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(translation(context).color),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickedColor!,
          onColorChanged: (color) {
            setState(() {
              pickedColor = color;
            });
          },
          showLabel: false,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actionsAlignment: MainAxisAlignment.start,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: ElevatedButton(
            child: Text(translation(context).save),
            onPressed: () {
              Navigator.of(context).pop(pickedColor);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextButton(
            child: Text(translation(context).cancel),
            onPressed: () {
              Navigator.of(context).pop(widget.initialColor);
            },
          ),
        ),
      ],
    );
  }
}
