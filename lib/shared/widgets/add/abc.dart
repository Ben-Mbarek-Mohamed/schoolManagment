import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:madrasti/models/student.dart';
import 'package:madrasti/providers/studentProvider.dart';
import 'package:madrasti/shared/services/ammountService.dart';
import 'package:madrasti/shared/services/studentService.dart';

import '../../../models/group.dart';
import '../../../providers/ammountProvider.dart';
import '../../../providers/expencesProvider.dart';
import '../../services/grouService.dart';
import '../myImagePicker.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  DateTime? regDate;
  DateTime? birhtDate;
  List<Groupe>? groups = [];
  List<Groupe>? selectedGroups = [];
  String? base64Image;
  Image? image;
  double ammount = 0;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _levelController = new TextEditingController();
  TextEditingController _ammountController = new TextEditingController();

  StudentService studentService = new StudentService();
  GroupService groupService = new GroupService();
  AmmountService ammountService = new AmmountService();
  Groupe? currentGroupe;

  @override
  void initState() {
    super.initState();
    this.groups = groupService.getAll();
  }

  void onImageSelected(String base64, Image img) {
    setState(() {
      base64Image = base64;
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(18),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translation(context).add_student + " :",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.print,
                                color: Colors.green,
                                size: 40,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                translation(context).print,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Text(translation(context).pre_payment + " :"),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Dialog(
                                            child: Container(
                                              height: 350,
                                              width: 400,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 20),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            28.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            translation(context)
                                                                    .group +
                                                                ' : '),
                                                        SizedBox(width: 20),
                                                        (currentGroupe != null)
                                                            ? DropdownButton<
                                                                Groupe>(
                                                                hint: Text(
                                                                    translation(
                                                                            context)
                                                                        .groups),
                                                                value:
                                                                    currentGroupe,
                                                                items: selectedGroups!
                                                                    .map((Groupe
                                                                        item) {
                                                                  return DropdownMenuItem<
                                                                      Groupe>(
                                                                    child: Text(
                                                                        item.name!),
                                                                    value: item,
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (Groupe?
                                                                        value) {
                                                                  setState(() {
                                                                    currentGroupe =
                                                                        value;
                                                                  });
                                                                },
                                                              )
                                                            : Text(''),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: TextFormField(
                                                      controller:
                                                          _ammountController,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'^\d*\.?\d{0,2}')),
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .blueAccent),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            translation(context)
                                                                .ammount,
                                                        hintText: (ammount > 0)
                                                            ? ammount.toString()
                                                            : '',
                                                        labelStyle: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 40),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 18),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            if (_ammountController
                                                                .text
                                                                .isNotEmpty) {
                                                              ammount = double
                                                                  .tryParse(
                                                                      _ammountController
                                                                          .text)!;
                                                            }

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          icon: Icon(
                                                            Icons.done,
                                                            color: Colors.green,
                                                            size: 35,
                                                          ),
                                                        ),
                                                        SizedBox(width: 20),
                                                        IconButton(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                            size: 35,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.credit_card_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      translation(context).pre_payment,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    )
                                  ],
                                ),
                                style: ButtonStyle(
                                  elevation: MaterialStatePropertyAll(5),
                                  fixedSize:
                                      MaterialStatePropertyAll(Size(150, 40)),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.green),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Text(
                                (ammount > 0)
                                    ? translation(context).paid +
                                        ' : ${ammount.toString()}'
                                    : '',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 30),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            translation(context).add_to_group + ' :',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            height: 80,
                            width: 500,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: (groups != null) ? groups!.length : 0,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Checkbox(
                                      value: selectedGroups!
                                          .contains(groups![index]),
                                      onChanged: (val) {
                                        setState(() {
                                          if (val == true) {
                                            selectedGroups!.add(groups![index]);
                                          } else {
                                            selectedGroups!
                                                .remove(groups![index]);
                                          }
                                        });
                                      },
                                    ),
                                    Text(groups![index].name!),
                                    SizedBox(width: 20),
                                  ],
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                                border: OutlineInputBorder(),
                                labelText: translation(context).name,
                                hintText: 'ABC',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                                border: OutlineInputBorder(),
                                labelText: translation(context).last_name,
                                hintText: 'ABC',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _levelController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                                border: OutlineInputBorder(),
                                labelText: translation(context).level,
                                hintText: 'ABC',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Column(
                            children: [
                              Text(translation(context).reg_date + " :"),
                              SizedBox(height: 20),
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
                                child: Text(
                                  (regDate == null)
                                      ? translation(context).select_date
                                      : DateFormat('yyyy-MM-dd')
                                          .format(regDate!),
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.blueAccent),
                                  fixedSize:
                                      MaterialStatePropertyAll(Size(150, 40)),
                                  elevation: MaterialStatePropertyAll(5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: size.width * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Row(
                            children: [
                              SizedBox(width: 130),
                            ],
                          ),
                          SizedBox(height: 160),
                          Row(
                            children: [
                              SizedBox(width: 130),
                              image != null
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          image = null;
                                        });
                                      },
                                      child: Container(
                                          height: 200,
                                          width: 200,
                                          child: image!),
                                    )
                                  : Column(
                                      children: [
                                        Text(translation(context).upload_image),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ImagePickerWidget(
                                            onImageSelected: onImageSelected),
                                      ],
                                    ),
                            ],
                          ),
                          SizedBox(height: 140),
                          Row(
                            children: [
                              SizedBox(width: 150),
                              Column(
                                children: [
                                  Text(translation(context).birth_date + " :"),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2101),
                                      );
                                      if (birhtDate != picked &&
                                          picked != null) {
                                        setState(() {
                                          birhtDate = picked;
                                        });
                                      }
                                    },
                                    child: Text(
                                      (birhtDate == null)
                                          ? translation(context).select_date
                                          : DateFormat('yyyy-MM-dd')
                                              .format(birhtDate!),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.blueAccent),
                                      fixedSize: MaterialStatePropertyAll(
                                          Size(150, 40)),
                                      elevation: MaterialStatePropertyAll(5),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        Student student = Student(
                          id: 0,
                          firstName: _nameController.text,
                          lastName: _lastNameController.text,
                          registrationDate: regDate,
                          birthDate: birhtDate,
                          image: base64Image,
                          requiredAmmount: [],
                          payedAmmount: [],
                          registrationNumber: 1720557913.toString(),
                          absences: [],
                          groups: (selectedGroups!.isNotEmpty)
                              ? selectedGroups!.map((e) => e.id!).toList()
                              : [],
                          level: _levelController.text,
                        );

                        if (_nameController.text.isNotEmpty &&
                            _lastNameController.text.isNotEmpty &&
                            _levelController.text.isNotEmpty &&
                            regDate != null &&
                            birhtDate != null &&
                            selectedGroups!.isNotEmpty) {
                          Student std = await studentService.add(student);
                          Navigator.of(context).pop();
                          setState(() {
                            setAllStudents(studentService.getAll(), context);
                            setFiltredStudents(
                                studentService.getAll(), context);
                            if (ammount != 0 && currentGroupe != null) {
                              Ammount ammount = Ammount(
                                date: DateTime.now(),
                                ammount:
                                    double.tryParse(_ammountController.text),
                                name: _nameController.text,
                                isExpence: false,
                                personId: std.id,
                                groupId: currentGroupe!.id,
                              );
                              std.payedAmmount!.add(ammount);
                              studentService.update(std);
                              ammountService.add(ammount);
                              setAllAmmounts(
                                  ammountService
                                      .getAll()
                                      .where((element) =>
                                          element.isExpence == false)
                                      .toList(),
                                  context);
                              setAllExpences(
                                  ammountService
                                      .getAll()
                                      .where((element) =>
                                          element.isExpence == true)
                                      .toList(),
                                  context);
                            }
                            if ((selectedGroups!.isNotEmpty)) {
                              for (Groupe group in selectedGroups!) {
                                group.studentsId!.add(std.id!.toString() +
                                    '?' +
                                    DateTime.now().toString());
                                groupService.update(group);
                              }
                            }
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                Future.delayed(Duration(seconds: 3), () {
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
                                        style: TextStyle(
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
                      icon: Icon(
                        Icons.done,
                        color: Colors.green,
                        size: 35,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      translation(context).save,
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                SizedBox(width: 40),
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      translation(context).cancel,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    )
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
