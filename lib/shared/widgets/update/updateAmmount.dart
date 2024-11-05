import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:madrasti/models/student.dart';
import 'package:madrasti/providers/ammountProvider.dart';
import 'package:madrasti/providers/expencesProvider.dart';
import 'package:madrasti/providers/profProvider.dart';
import 'package:madrasti/providers/studentProvider.dart';
import 'package:madrasti/shared/services/ammountService.dart';
import 'package:madrasti/shared/services/profService.dart';
import 'package:madrasti/shared/services/studentService.dart';

import '../../../language_utils/language_constants.dart';
import '../../../models/prof.dart';

class UpdateAmmount extends StatefulWidget {
  final Ammount selectedAmmount;
  const UpdateAmmount({super.key, required this.selectedAmmount});

  @override
  State<UpdateAmmount> createState() => _UpdateAmmountState();
}

class _UpdateAmmountState extends State<UpdateAmmount> {

  bool isExpences = false;
  DateTime? date = DateTime.now();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _ammountController = new TextEditingController();

  AmmountService ammountService = new AmmountService();
  StudentService studentService = new StudentService();
  ProfService profService = new ProfService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isExpences = widget.selectedAmmount.isExpence!;
    this.date = widget.selectedAmmount.date;
    _nameController.text = widget.selectedAmmount.name!;
    _ammountController.text = widget.selectedAmmount.ammount.toString();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.6,
      height: 600,
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
                          ammountService.delete(widget.selectedAmmount.id!);
                          if(widget.selectedAmmount.isExpence!){
                            var filtred = getAllExpences(context);
                            filtred!.remove(widget.selectedAmmount);
                            setAllExpences(filtred, context);
                          }
                          else{
                            var filtred = getAllAmmounts(context);
                            filtred!.remove(widget.selectedAmmount);
                            setAllAmmounts(filtred, context);
                          }
                          Ammount ammount = widget.selectedAmmount;
                          if(ammount.personId.toString().length != 12){
                            if(ammount.personId != null){
                              if(getFiltredStudents(context) != null) {
                                if (getFiltredStudents(context)!.any((
                                    element) =>
                                element.id == ammount.personId!)) {
                                  Student? std = studentService.get(
                                      ammount.personId!);
                                  if (std != null && std.payedAmmount!.any((element) =>
                                  element.ammount ==
                                      widget.selectedAmmount.ammount &&
                                      element.date ==
                                          widget.selectedAmmount.date
                                      && widget.selectedAmmount.groupId == element.groupId
                                  )) {
                                    Ammount amt = std.payedAmmount!.firstWhere(
                                            (element) =>
                                    element.ammount ==
                                        widget.selectedAmmount.ammount &&
                                        element.date ==
                                            widget.selectedAmmount.date
                                        && widget.selectedAmmount.groupId == element.groupId
                                    );
                                    std.payedAmmount!.remove(amt);
                                    studentService.update(std);
                                  }
                                }
                              }

                            }
                          }else{
                            if(ammount.personId != null){
                              int pid = ammount.personId! - 111720557913;
                              if(getFiltredProfs(context) != null) {
                                if (getFiltredProfs(context)!.any((
                                    element) =>
                                element.id == pid)) {
                                  Prof? prf = profService.get(pid);
                                  if (prf != null && prf.payedAmmount!.any((element) =>
                                  element.ammount ==
                                      widget.selectedAmmount.ammount &&
                                      element.date ==
                                          widget.selectedAmmount.date
                                      && widget.selectedAmmount.groupId == element.groupId
                                  )) {
                                    Ammount amt = prf.payedAmmount!.firstWhere((
                                        element) =>
                                    element.ammount ==
                                        widget.selectedAmmount.ammount &&
                                        element.date ==
                                            widget.selectedAmmount.date
                                        && widget.selectedAmmount.groupId == element.groupId
                                    );
                                    prf.payedAmmount!.remove(amt);
                                    profService.update(prf);
                                  }
                                }
                              }
                            }
                          }
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
                  hintText: 'ABC',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                controller: _ammountController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                  border: const OutlineInputBorder(),

                  labelText: translation(context).ammount,
                  hintText: '200',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(translation(context).date),
                  ),
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
                      if (date != picked && picked != null) {
                        setState(() {
                          date = picked;

                        });
                      }
                    },
                    child: Text(
                      (date == null)
                          ? translation(context).select_date
                          : DateFormat('yyyy-MM-dd').format(date!),
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
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if(_nameController.text.isNotEmpty && _ammountController.text.isNotEmpty){
                          Ammount ammount = Ammount(
                            id: widget.selectedAmmount.id,
                            date: date,
                            ammount: double.tryParse(_ammountController.text),
                            name: _nameController.text,
                            isExpence: isExpences,
                            groupId: widget.selectedAmmount.groupId,
                            personId: widget.selectedAmmount.personId
                          );
                          ammountService.update(ammount);
                          if(ammount.personId.toString().length != 12){
                            if(ammount.personId != null){
                              if(getFiltredStudents(context) != null) {
                                if (getFiltredStudents(context)!.any((
                                    element) =>
                                element.id == ammount.personId!)) {
                                  Student? std = studentService.get(
                                      ammount.personId!);
                                  if (std != null &&
                                      std.payedAmmount!.any((element) =>
                                      element.ammount ==
                                          widget.selectedAmmount.ammount &&
                                          element.date ==
                                              widget.selectedAmmount.date
                                          && widget.selectedAmmount.groupId ==
                                          element.groupId
                                      )) {
                                    Ammount amt = std.payedAmmount!.firstWhere((
                                        element) =>
                                    element.ammount ==
                                        widget.selectedAmmount.ammount &&
                                        element.date ==
                                            widget.selectedAmmount.date &&
                                        widget.selectedAmmount.groupId ==
                                            element.groupId);
                                    std.payedAmmount!.remove(amt);
                                    std.payedAmmount!.add(ammount);
                                    studentService.update(std);
                                  }
                                }
                              }

                            }
                          }else{
                            if(ammount.personId != null){
                              int pid = ammount.personId! - 111720557913;
                              if(getFiltredProfs(context) != null) {
                                if (getFiltredProfs(context)!.any((
                                    element) =>
                                element.id == pid)) {
                                  Prof? prf = profService.get(pid);
                                  if (prf != null &&
                                      prf.payedAmmount!.any((element) =>
                                      element.ammount ==
                                          widget.selectedAmmount.ammount &&
                                          element.date ==
                                              widget.selectedAmmount.date
                                          && widget.selectedAmmount.groupId ==
                                          element.groupId
                                      )) {
                                    Ammount amt = prf.payedAmmount!.firstWhere((
                                        element) =>
                                    element.ammount ==
                                        widget.selectedAmmount.ammount &&
                                        element.date ==
                                            widget.selectedAmmount.date &&
                                        widget.selectedAmmount.groupId ==
                                            element.groupId);
                                    prf.payedAmmount!.remove(amt);
                                    prf.payedAmmount!.add(ammount);
                                    profService.update(prf);
                                  }
                                }
                              }
                            }
                          }

                          setAllAmmounts(ammountService.getAll().where((element) => element.isExpence == false).toList(), context);
                          setAllExpences(ammountService.getAll().where((element) => element.isExpence == true).toList(), context);
                          Navigator.of(context).pop();


                        }
                        else{
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
                      child: Text(translation(context).save, style: const  TextStyle(color: Colors.green, fontWeight: FontWeight.w600,fontSize: 20),),
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
                      child:  Text(translation(context).cancel, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600,fontSize: 20),),
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
