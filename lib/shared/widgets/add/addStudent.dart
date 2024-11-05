import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:madrasti/providers/studentProvider.dart';
import 'package:madrasti/shared/services/ammountService.dart';
import 'package:madrasti/shared/services/studentService.dart';

import '../../../models/group.dart';
import '../../../models/student.dart';
import '../../../providers/ammountProvider.dart';
import '../../../providers/expencesProvider.dart';
import '../../pdfUtils/generateBoonPdf.dart';
import '../../services/attendanceService.dart';
import '../../services/grouService.dart';
import '../myImagePicker.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudent();
}

class _AddStudent extends State<AddStudent> {
  DateTime? regDate;
  DateTime? birhtDate;
  List<Groupe>? groups = [];
  List<Groupe>? selectedGroups = [];
  String? base64Image;
  Image? image;
  double ammount = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _ammountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  StudentService studentService = StudentService();
  GroupService groupService = GroupService();
  AmmountService ammountService = AmmountService();
  Groupe? currentGroupe;

  @override
  void initState() {
    super.initState();
    groups = groupService.getAll();
  }

  void onImageSelected(String base64, Image img) {
    setState(() {
      base64Image = base64;
      image = img;
    });
  }

  updateData() {}

  @override
  Widget build(BuildContext context) {
    currentGroupe =
        selectedGroups!.isNotEmpty ? selectedGroups!.first : null;
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${translation(context).add_student} :",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                    const Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 30),

                              ElevatedButton(
                                onPressed: () async {
                                 bool? res = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Dialog(
                                            child: SizedBox(
                                              height: 350,
                                              width: 400,
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 20),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            28.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            '${translation(context)
                                                                    .group} : '),
                                                        const SizedBox(width: 20),
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
                                                                    value: item,
                                                                    child: Text(
                                                                        item.name!),
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
                                                            : const Text(''),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
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
                                                            const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .blueAccent),
                                                        ),
                                                        border:
                                                            const OutlineInputBorder(),
                                                        labelText:
                                                            translation(context)
                                                                .ammount,
                                                        hintText: (ammount > 0)
                                                            ? ammount.toString()
                                                            : '',
                                                        labelStyle: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 40),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 18),
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                if (_ammountController
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  setState(() {
                                                                    ammount = double
                                                                        .tryParse(
                                                                        _ammountController
                                                                            .text)!;
                                                                  });

                                                                }

                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true);

                                                                if(ammount > 0){
                                                                  showDialog<String>(
                                                                    context: context,
                                                                    builder: (BuildContext context) =>
                                                                        Dialog(
                                                                          child: SizedBox(
                                                                            height: 170,
                                                                            width: 200,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(18.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(translation(context).print_recipt,style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                                                                                  const SizedBox(height: 40,),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          ElevatedButton(
                                                                                            onPressed: (){
                                                                                              if(currentGroupe != null) {
                                                                                                generateBoonPdf(
                                                                                                    _nameController
                                                                                                        .text ??
                                                                                                        '',
                                                                                                    _lastNameController
                                                                                                        .text ??
                                                                                                        '',
                                                                                                    ammount
                                                                                                        .toStringAsFixed(2),
                                                                                                    currentGroupe!
                                                                                                        .name ??
                                                                                                        '',
                                                                                                    context
                                                                                                );
                                                                                              }
                                                                                            },
                                                                                            child: Text(translation(context).print),
                                                                                          ),
                                                                                          const SizedBox(width: 20,),
                                                                                          ElevatedButton(
                                                                                            onPressed: (){
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                            child: Text(translation(context).cancel),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      const SizedBox(),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
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
                                                            const SizedBox(height: 10,),
                                                            Text(translation(context).save, style: const TextStyle(color: Colors.green,fontWeight: FontWeight.w600),)
                                                          ],
                                                        ),
                                                        const SizedBox(width: 20),
                                                        Column(
                                                          children: [
                                                            IconButton(
                                                              onPressed: () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true);
                                                              },
                                                              icon: const Icon(
                                                                Icons.close,
                                                                color: Colors.red,
                                                                size: 35,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10,),
                                                            Text(translation(context).cancel, style: const TextStyle(color: Colors.red,fontWeight: FontWeight.w600),)
                                                          ],
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
                                 if (res == true){
                                   setState(() {

                                   });
                                 }
                                },
                                style: const ButtonStyle(
                                  elevation: MaterialStatePropertyAll(5),
                                  fixedSize:
                                      MaterialStatePropertyAll(Size(150, 40)),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.green),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.credit_card_outlined,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      translation(context).pre_payment,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              const SizedBox(width: 30),
                              Text(
                                (ammount > 0)
                                    ? '${translation(context).paid} : ${ammount.toString()}'
                                    : '',
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 30),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${translation(context).add_to_group} :',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
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
                                      const SizedBox(width: 20),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
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
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
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
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _levelController,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                                border: const OutlineInputBorder(),
                                labelText: translation(context).level,
                                hintText: 'ABC',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.blueAccent),
                                ),
                                border: const OutlineInputBorder(),
                                labelText: translation(context).phone_num,
                                hintText: '123123',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Column(
                            children: [
                              Text("${translation(context).reg_date} :"),
                              const SizedBox(height: 20),
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
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.blueAccent),
                                  fixedSize:
                                      MaterialStatePropertyAll(Size(150, 40)),
                                  elevation: MaterialStatePropertyAll(5),
                                ),
                                child: Text(
                                  (regDate == null)
                                      ? translation(context).select_date
                                      : DateFormat('yyyy-MM-dd')
                                          .format(regDate!),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: size.width * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Row(
                            children: [
                              SizedBox(width: 130),
                            ],
                          ),
                          const SizedBox(height: 190),
                          Row(
                            children: [
                              const SizedBox(width: 150),
                              image != null
                                  ? SizedBox(
                                      height: 190,
                                      width: 200,
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  image = null;
                                                });
                                              },
                                              child: Text(
                                                translation(context).delete,
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              )),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          image!,
                                        ],
                                      ))
                                  : Column(
                                      children: [
                                        Text(translation(context).upload_image),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ImagePickerWidget(
                                            onImageSelected: onImageSelected),
                                      ],
                                    ),
                            ],
                          ),
                          const SizedBox(height: 110),

                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.blueAccent),
                                ),
                                border: const OutlineInputBorder(),
                                labelText: translation(context).address,
                                hintText: 'ABC',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              const SizedBox(width: 150),
                              Column(
                                children: [
                                  Text("${translation(context).birth_date} :"),
                                  const SizedBox(height: 20),
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
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.blueAccent),
                                      fixedSize: MaterialStatePropertyAll(
                                          Size(150, 40)),
                                      elevation: MaterialStatePropertyAll(5),
                                    ),
                                    child: Text(
                                      (birhtDate == null)
                                          ? translation(context).select_date
                                          : DateFormat('yyyy-MM-dd')
                                              .format(birhtDate!),
                                      style: const TextStyle(color: Colors.white),
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
            const SizedBox(height: 50),
            Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
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
                          phone: _phoneController.text ?? '',
                          address: _addressController.text ?? ''

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
                            setFiltredStudents(studentService.getAll(), context);
                            if (ammount != 0 && currentGroupe != null) {
                              Ammount ammount = Ammount(
                                date: DateTime.now(),
                                ammount: double.tryParse(_ammountController.text),
                                name: '${std.firstName!} ${std.lastName!}',
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
                                      .where(
                                          (element) => element.isExpence == false)
                                      .toList(),
                                  context);
                              setAllExpences(
                                  ammountService
                                      .getAll()
                                      .where((element) => element.isExpence == true)
                                      .toList(),
                                  context);
                            }
                            if ((selectedGroups!.isNotEmpty)) {
                              for (Groupe group in selectedGroups!) {
                                group.studentsId!.add('${std.id!}?${DateTime.now()}');
                                groupService.update(group);
                              }
                            }
                          });
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
                                  child: SizedBox(
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
                      child: Text(translation(context).save, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 20),),
                    ),
                    const SizedBox(height: 10,),

                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                      child:Text(translation(context).cancel, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 20),),
                    ),
                    const SizedBox(height: 10,),

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

double getRequiredAmmount(Student student, context) {
  GroupService groupService = GroupService();
  AttendanceService attendanceService = AttendanceService();
  StudentService studentService = StudentService();
  double result = 0;
  for (Ammount ammount in student.requiredAmmount!) {
    result += ammount.ammount!;
  }
  for (Ammount ammount in student.payedAmmount!) {
    result -= ammount.ammount!;
  }

  return result;
}
