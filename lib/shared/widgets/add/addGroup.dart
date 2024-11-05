import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/models/group.dart';
import 'package:madrasti/models/sessionTime.dart';
import 'package:madrasti/providers/groupProvider.dart';
import 'package:madrasti/shared/services/grouService.dart';

import '../../../language_utils/language_constants.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({super.key});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  DateTime? startDate;
  DateTime? endDate;

  bool isRegular = true;
  bool isSession = false;

  bool isPoucentage = false;
  bool isMonthly = true;
  double _currentSliderValue = 50;

  List<String> groupDays = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentController = TextEditingController();
  final TextEditingController _profController = TextEditingController();
  final TextEditingController _absenceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  GroupService groupService = GroupService();

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }
    final numValue = num.tryParse(value);
    if (numValue == null || numValue <= 0) {
      return 'Please enter a valid positive number';
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.7,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            Text(
              '${translation(context).add} ${translation(context).group} :',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Text(
                    '${translation(context).system} :',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isSession) {
                        setState(() {
                          isRegular = true;
                          isSession = false;
                        });
                      }
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: (isRegular)
                          ? BoxDecoration(
                              borderRadius:
                                  (translation(context).session == 'حصة')
                                      ? const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        )
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                              border: Border.all(
                                  width: 1, color: Colors.blueAccent),
                              color: Colors.blue)
                          : BoxDecoration(
                              borderRadius:
                                  (translation(context).session != 'حصة')
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        )
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                              border: Border.all(width: 0.5),
                            ),
                      child: Center(
                        child: Text(
                          translation(context).regular,
                          style: TextStyle(
                              color: (isRegular) ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isRegular) {
                        setState(() {
                          isRegular = false;
                          isSession = true;
                        });
                      }
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: (isSession)
                          ? BoxDecoration(
                              borderRadius:
                                  (translation(context).session != 'حصة')
                                      ? const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        )
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                              border: Border.all(
                                  width: 1, color: Colors.blueAccent),
                              color: Colors.blue)
                          : BoxDecoration(
                              borderRadius:
                                  (translation(context).session != 'حصة')
                                      ? const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        )
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                              border: Border.all(width: 0.5),
                            ),
                      child: Center(
                        child: Text(
                          translation(context).session,
                          style: TextStyle(
                              color: (isSession) ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                controller: _nameController,
                validator: _validateInput,
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                  border: const OutlineInputBorder(),
                  labelText: translation(context).name,
                  hintText: '${translation(context).group} 1',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 50,
                ),
                Column(
                  children: [
                    Text(translation(context).start_date),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (startDate != picked && picked != null) {
                          setState(() {
                            startDate = picked;
                            print(startDate);
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
                        (startDate == null)
                            ? translation(context).select_date
                            : DateFormat('yyyy-MM-dd').format(startDate!),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 300,
                ),
                Column(
                  children: [
                    Text(translation(context).end_date),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (endDate != picked && picked != null) {
                          setState(() {
                            endDate = picked;
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
                        (endDate == null)
                            ? translation(context).select_date
                            : DateFormat('yyyy-MM-dd').format(endDate!),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                validator: _validateInput,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                controller: _studentController,
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
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                controller: _absenceController,
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
            Row(
              children: [
                Text(
                  '${translation(context).payment_method_prof} :',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 150,
                  child: CheckboxListTile(
                    value: isMonthly,
                    onChanged: (val) {
                      setState(() {
                        isMonthly = val ?? false;
                        if (isMonthly == true) {
                          isPoucentage = false;
                        }
                      });
                    },
                    title: Text(translation(context).regular),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 190,
                  child: CheckboxListTile(
                    value: isPoucentage,
                    onChanged: (val) {
                      setState(() {
                        isPoucentage = val ?? false;
                        if (isPoucentage == true) {
                          isMonthly = false;
                        }
                      });
                    },
                    title: Text(translation(context).percentage),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            (isMonthly)
                ? Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      controller: _profController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
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
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        translation(context).prof_percentage,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Slider(
                        value: _currentSliderValue,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                      ),
                      Text(
                        '${_currentSliderValue.round()}%',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
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
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blueAccent),
                        fixedSize: MaterialStatePropertyAll(Size(150, 40)),
                        elevation: MaterialStatePropertyAll(5),
                      ),
                      child: Text(
                        (startTime == null)
                            ? translation(context).start_time
                            : startTime!.format(context),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 350,
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
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blueAccent),
                        fixedSize: MaterialStatePropertyAll(Size(150, 40)),
                        elevation: MaterialStatePropertyAll(5),
                      ),
                      child: Text(
                        (endTime == null)
                            ? translation(context).end_time
                            : endTime!.format(context),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${translation(context).number_of_sessions} : ${groupDays.length}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
              height: 50,
            ),
            Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Groupe gr = Groupe(
                            id: 0,
                            name: _nameController.text,
                            startDate: startDate,
                            endDate: endDate,
                            isProfPaymentRegular: isMonthly,
                            isRegular: isRegular,
                            profsId: [],
                            studentsId: [],
                            sessionDays: groupDays!
                                .map((e) => SessionTime(
                                    day: e, startTime: startTime, endTime: endTime))
                                .toList(),
                            profPoucentage: _currentSliderValue,
                            profPrice: double.tryParse(_profController.text),
                            studentPrice: double.tryParse(_studentController.text),
                            absenceAmmount:
                                double.tryParse(_absenceController.text));
                        if (gr.name != null &&
                            gr.name != '' &&
                            gr.startDate != null &&
                            gr.endDate != null &&
                            gr.isProfPaymentRegular != null &&
                            gr.isRegular != null &&
                            gr.sessionDays!.isNotEmpty &&
                            gr.absenceAmmount != null &&
                            gr.absenceAmmount != '' &&
                            gr.studentPrice != null &&
                            startTime != null &&
                            endTime != null) {
                          if (gr.isProfPaymentRegular!) {
                            if (gr.profPrice != null && gr.profPrice != '') {
                              groupService.add(gr);
                              Navigator.of(context).pop();
                              setState(() {
                                setAllGroups(context, groupService.getAll());
                                setFiltredGroups(context, groupService.getAll());
                              });
                            }
                          } else {
                            groupService.add(gr);
                            setAllGroups(context, groupService.getAll());
                            setFiltredGroups(context, groupService.getAll());
                            Navigator.of(context).pop();
                          }
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
                                    )),
                                  ),
                                );
                              });
                        }
                      },
                      child: Text(translation(context).save, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 20),),
                    ),
                    const SizedBox(height: 10,),

                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text(translation(context).cancel, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600,fontSize: 20),),
                    ),
                    const SizedBox(height: 10,),

                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
