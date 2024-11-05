import 'dart:convert';

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
import '../../pdfUtils/generateBoonPdf.dart';
import '../../pdfUtils/generateStudentCard.dart';
import '../../services/attendanceService.dart';
import '../../services/grouService.dart';
import '../myImagePicker.dart';

class UpdateStudent extends StatefulWidget {
  final Student selectedStudent;
  final Groupe? selectedGroup;

  const UpdateStudent(
      {super.key, required this.selectedStudent, this.selectedGroup});

  @override
  State<UpdateStudent> createState() => _UpdateStudent();
}

class _UpdateStudent extends State<UpdateStudent> {

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
  late Student currentStudent;

  void _onDialogClosed() {
    setState(() {});
  }

  @override
  void initState() {
    currentStudent = widget.selectedStudent;
    super.initState();
    groups = groupService.getAll();
    selectedGroups = widget.selectedStudent.groups!.map((id) {
      return groups!.firstWhere((group) => group.id == id);
    }).toList();

    _nameController.text = widget.selectedStudent.firstName!;
    _lastNameController.text = widget.selectedStudent.lastName!;
    _levelController.text = widget.selectedStudent.level!;
    _phoneController.text = widget.selectedStudent.phone ?? '';
    _addressController.text = widget.selectedStudent.address ?? '';
    regDate = widget.selectedStudent.registrationDate;
    birhtDate = widget.selectedStudent.birthDate;
    base64Image = widget.selectedStudent.image;
    image =
    base64Image != null ? Image.memory(base64Decode(base64Image!)) : null;
    currentGroupe =
    selectedGroups!.isNotEmpty ? selectedGroups!.first : null;
  }

  void onImageSelected(String base64, Image img) {
    setState(() {
      base64Image = base64;
      image = img;
    });
  }


  @override
  Widget build(BuildContext context) {
    currentGroupe =
    selectedGroups!.isNotEmpty ? selectedGroups!.first : null;
    Size size = MediaQuery
        .of(context)
        .size;
    var requiredAmount = getRequiredAmmount(widget.selectedStudent, context);
    var isAmountPositive = requiredAmount > 0;
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
                      translation(context).info + " :",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (widget.selectedGroup != null) ? Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Groupe gr = widget.selectedGroup!;
                                      Student std = widget.selectedStudent;
                                      std.groups!.remove(gr.id);
                                      studentService.update(std);
                                      String stdInfo = gr.studentsId!
                                          .firstWhere((element) =>
                                      element
                                          .split('?')
                                          .first == std.id.toString());
                                      gr.studentsId!.remove(stdInfo);
                                      groupService.update(gr);
                                      Navigator.of(context).pop();
                                      List<
                                          Student>? filtred = getFiltredStudents(
                                          context);
                                      if (filtred != null) {
                                        filtred.remove(std);
                                      }
                                      setFiltredStudents(filtred, context);
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever_outlined,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                  const SizedBox(width: 25,),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 100,
                                child: Center(
                                  child: Text(
                                    translation(context).delete_from_group,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ) : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  List<int> gorupsIds = widget.selectedStudent
                                      .groups!;
                                  for (int id in gorupsIds) {
                                    Groupe gr = groupService.get(id)!;
                                    String stdId = gr.studentsId!.firstWhere((
                                        element) =>
                                    element
                                        .split('?')
                                        .first ==
                                        widget.selectedStudent.id.toString());
                                    gr.studentsId!.remove(stdId);
                                    groupService.update(gr);
                                  }
                                  studentService.delete(
                                      widget.selectedStudent.id!);
                                  setAllStudents(
                                      studentService.getAll(), context);
                                  setFiltredStudents(
                                      studentService.getAll(), context);
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
                        const SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  generateStudentCardPdf(
                                      widget.selectedStudent, context);
                                },
                                icon: const Icon(
                                  Icons.print,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                translation(context).print,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 30),

                              ElevatedButton(
                                onPressed: () async {
                                  bool? result = await showDialog(
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
                                                  const SizedBox(height: 20),
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
                                                        hintText: '',
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
                                                                  ammount =
                                                                  double
                                                                      .tryParse(
                                                                      _ammountController
                                                                          .text)!;
                                                                  if (ammount !=
                                                                      0 &&
                                                                      currentGroupe !=
                                                                          null) {
                                                                    Ammount
                                                                    ammount =
                                                                    Ammount(
                                                                      date: DateTime
                                                                          .now(),
                                                                      ammount: double
                                                                          .tryParse(
                                                                          _ammountController
                                                                              .text),
                                                                      name
                                                                          : '${widget.selectedStudent.
                                                                      firstName!} ${widget.selectedStudent.
                                                                      lastName!}',
                                                                      isExpence:
                                                                      false,
                                                                      personId: widget
                                                                          .selectedStudent
                                                                          .id,
                                                                      groupId:
                                                                      currentGroupe!
                                                                          .id,
                                                                    );
                                                                    widget
                                                                        .selectedStudent
                                                                        .payedAmmount!
                                                                        .add(
                                                                        ammount);
                                                                    studentService
                                                                        .update(
                                                                        widget
                                                                            .selectedStudent);
                                                                    ammountService
                                                                        .add(
                                                                        ammount);
                                                                    setAllAmmounts(
                                                                        ammountService
                                                                            .getAll()
                                                                            .where((
                                                                            element) =>
                                                                        element
                                                                            .isExpence ==
                                                                            false)
                                                                            .toList(),
                                                                        context);
                                                                    setAllExpences(
                                                                        ammountService
                                                                            .getAll()
                                                                            .where((
                                                                            element) =>
                                                                        element
                                                                            .isExpence ==
                                                                            true)
                                                                            .toList(),
                                                                        context);

                                                                    setAllStudents(
                                                                        studentService
                                                                            .getAll(),
                                                                        context);
                                                                    setFiltredStudents(
                                                                        studentService
                                                                            .getAll(),
                                                                        context);
                                                                    setState(() {});
                                                                  }
                                                                }

                                                                Navigator.of(
                                                                    context)
                                                                    .pop(true);
                                                                if(_ammountController.text.isNotEmpty){
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
                                                                }
                                                              },
                                                              icon: const Icon(
                                                                Icons.done,
                                                                color: Colors
                                                                    .green,
                                                                size: 35,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,),
                                                            Text(translation(
                                                                context).save,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .green),),
                                                          ],
                                                        ),
                                                        const SizedBox(width: 20),
                                                        Column(
                                                          children: [
                                                            Column(
                                                              children: [
                                                                IconButton(
                                                                  onPressed: () async {
                                                                    Navigator
                                                                        .of(
                                                                        context)
                                                                        .pop();
                                                                  },
                                                                  icon: const Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 35,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,),
                                                                Text(
                                                                  translation(
                                                                      context)
                                                                      .cancel,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .red),),
                                                              ],
                                                            ),
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
                                  if (result == true) {
                                    _onDialogClosed();
                                  }
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.credit_card_outlined,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      translation(context).payment,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    )
                                  ],
                                ),
                                style: const ButtonStyle(
                                  elevation: MaterialStatePropertyAll(5),
                                  fixedSize:
                                  MaterialStatePropertyAll(Size(150, 40)),
                                  backgroundColor:
                                  MaterialStatePropertyAll(Colors.green),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              const SizedBox(width: 30),
                              Text(
                                '${isAmountPositive ? translation(context)
                                    .required_amount : translation(context)
                                    .paid} : ${(requiredAmount != 0)
                                    ? requiredAmount.abs().toString()
                                    : ''}',
                                style: TextStyle(
                                  color: isAmountPositive
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 30),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            translation(context).add_to_group + ' :',
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
                                        value: selectedGroups!
                                            .contains(groups![index]),
                                        onChanged: (val) {

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
                              Text(translation(context).reg_date + " :"),
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
                                child: Text(
                                  (regDate == null)
                                      ? translation(context).select_date
                                      : DateFormat('yyyy-MM-dd')
                                      .format(regDate!),
                                  style: const TextStyle(color: Colors.white),
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
                    const SizedBox(width: 20),
                    Container(
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
                                  ? Container(
                                  height: 190,
                                  width: 200,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              image = null;
                                              base64Image = null;
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
                                      SizedBox(
                                        height: 120,
                                          child: image!),
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
                                  Text(translation(context).birth_date + " :"),
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
                                    child: Text(
                                      (birhtDate == null)
                                          ? translation(context).select_date
                                          : DateFormat('yyyy-MM-dd')
                                          .format(birhtDate!),
                                      style: const TextStyle(color: Colors.white),
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
            const SizedBox(height: 50),
            Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Student student = Student(
                          id: widget.selectedStudent.id,
                          firstName: _nameController.text,
                          lastName: _lastNameController.text,
                          registrationDate: regDate,
                          birthDate: birhtDate,
                          image: base64Image,
                          requiredAmmount: widget.selectedStudent
                              .requiredAmmount,
                          payedAmmount: widget.selectedStudent.payedAmmount,
                          registrationNumber:
                          widget.selectedStudent.registrationNumber,
                          absences: [],
                          groups: widget.selectedStudent.groups,
                          level: _levelController.text,
                          phone: _phoneController.text,
                          address: _addressController.text
                        );

                        if (_nameController.text.isNotEmpty &&
                            _lastNameController.text.isNotEmpty &&
                            _levelController.text.isNotEmpty &&
                            regDate != null &&
                            birhtDate != null &&
                            selectedGroups!.isNotEmpty) {
                          studentService.update(student);
                          Navigator.of(context).pop();
                          setState(() {
                            setAllStudents(studentService.getAll(), context);
                            setFiltredStudents(
                                studentService.getAll(), context);
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
                      child: Text(translation(context).save, style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w600,fontSize: 20),),
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
                      child: Text(translation(context).cancel, style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600,fontSize: 20),),
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
