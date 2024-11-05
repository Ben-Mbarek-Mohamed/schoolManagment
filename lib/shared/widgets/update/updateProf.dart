import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/providers/profProvider.dart';
import 'package:madrasti/shared/services/ammountService.dart';
import 'package:madrasti/shared/services/profService.dart';

import '../../../language_utils/language_constants.dart';
import '../../../models/ammount.dart';
import '../../../models/group.dart';
import '../../../models/prof.dart';
import '../../pdfUtils/generateBoonPdf.dart';
import '../../pdfUtils/generateProfCard.dart';
import '../../services/grouService.dart';
import '../myImagePicker.dart';

class UpdateProf extends StatefulWidget {
  final Prof selectedProf;
  final Groupe? selectedGroup;

  const UpdateProf({super.key, required this.selectedProf, this.selectedGroup});

  @override
  State<UpdateProf> createState() => _UpdateProfState();
}

class _UpdateProfState extends State<UpdateProf> {
  DateTime? regDate;
  DateTime? birhtDate;
  List<Groupe>? groups = [];
  List<Groupe>? selectedGroups = [];
  String? base64Image;
  Image? image;
  Groupe? currentGroupe;
  double ammount = 0;

  GroupService groupService = new GroupService();
  ProfService profService = new ProfService();
  AmmountService ammountService = new AmmountService();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _majorController = new TextEditingController();
  TextEditingController _ammountController = new TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.groups = groupService.getAll();
    this.selectedGroups = widget.selectedProf.groups!.map((id) {
      return groups!.firstWhere((group) => group.id == id);
    }).toList();
    _nameController.text = widget.selectedProf.firstName!;
    _lastNameController.text = widget.selectedProf.lastName!;
    _majorController.text = widget.selectedProf.major!;
    regDate = widget.selectedProf.registrationDate;
    birhtDate = widget.selectedProf.birthDate;
    base64Image = widget.selectedProf.image;
    image =
        base64Image != null ? Image.memory(base64Decode(base64Image!)) : null;
    this.currentGroupe =
        selectedGroups!.isNotEmpty ? selectedGroups!.first : null;
  }

  void onImageSelected(String base64, Image img) {
    setState(() {
      base64Image = base64;
      image = img;
    });
  }
  void _onDialogClosed() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var requiredAmount = getRequiredAmmount(widget.selectedProf, context);
    var isAmountPositive = requiredAmount > 1;
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
                        (widget.selectedGroup != null)?Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Groupe gr = widget.selectedGroup!;
                                      Prof pr = widget.selectedProf;
                                      pr.groups!.remove(gr.id);
                                      profService.update(pr);
                                      String profInfo = gr.profsId!.firstWhere((element) => element.split('?').first == pr.id.toString());
                                      gr.profsId!.remove(profInfo);
                                      groupService.update(gr);
                                      Navigator.of(context).pop();
                                      List<Prof>? filtred = getFiltredProfs(context);
                                      if(filtred != null) {
                                        filtred.remove(pr);
                                      }
                                      setFiltredProfs(filtred, context);
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
                        ):const SizedBox(),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  List<int> gorupsIds = widget.selectedProf.groups!;
                                  for(int id in gorupsIds){
                                    Groupe gr = groupService.get(id)!;
                                    String stdId = gr.profsId!.firstWhere((element) => element.split('?').first == widget.selectedProf.id.toString());
                                    gr.profsId!.remove(stdId);
                                    groupService.update(gr);
                                  }
                                  profService.delete(widget.selectedProf.id!);
                                  setAllProfs(profService.getAll(), context);
                                  setFiltredProfs(profService.getAll(), context);
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
                                  generateProfCardPdf(widget.selectedProf, context);
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
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
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
                                                            const EdgeInsets
                                                                .all(28.0),
                                                        child: Row(
                                                          children: [
                                                            Text(translation(
                                                                        context)
                                                                    .group +
                                                                ' : '),
                                                            const SizedBox(width: 20),
                                                            (currentGroupe !=
                                                                    null)
                                                                ? DropdownButton<
                                                                    Groupe>(
                                                                    hint: Text(translation(
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
                                                                        value:
                                                                            item,
                                                                      );
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (Groupe?
                                                                            value) {
                                                                      setState(
                                                                          () {
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
                                                            const EdgeInsets
                                                                .all(20.0),
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
                                                                translation(
                                                                        context)
                                                                    .ammount,
                                                            hintText : '',
                                                            labelStyle:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 40),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
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
                                                                      ammount = double
                                                                          .tryParse(
                                                                              _ammountController
                                                                                  .text)!;
                                                                      if (ammount !=
                                                                              0 &&
                                                                          currentGroupe !=
                                                                              null) {
                                                                        Ammount payedAmmount =
                                                                            Ammount(
                                                                          date: DateTime
                                                                              .now(),
                                                                          ammount: double.tryParse(
                                                                              _ammountController
                                                                                  .text),
                                                                          name: '${widget.selectedProf.firstName!} ${widget.selectedProf.lastName!}',
                                                                          isExpence:
                                                                              true,
                                                                          personId: int.parse(widget.selectedProf.registrationNumber!),
                                                                          groupId:
                                                                              currentGroupe!
                                                                                  .id,
                                                                        );
                                                                        if(widget.selectedProf.payedAmmount != null){
                                                                          widget
                                                                              .selectedProf
                                                                              .payedAmmount!
                                                                              .add(
                                                                              payedAmmount);
                                                                        }else{
                                                                          widget.selectedProf.payedAmmount = [payedAmmount];
                                                                        }

                                                                        ammountService.add(payedAmmount);
                                                                        profService.update(widget
                                                                            .selectedProf);
                                                                        setFiltredProfs(profService.getAll(), context);
                                                                        setState(
                                                                            () {});
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
                                                                const SizedBox(height: 10,),
                                                                Text(translation(context).save, style: const TextStyle(color: Colors.green),),
                                                              ],
                                                            ),
                                                            const SizedBox(width: 20),
                                                            Column(
                                                              children: [
                                                                IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  icon: const Icon(
                                                                    Icons.close,
                                                                    color:
                                                                        Colors.red,
                                                                    size: 35,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Text(translation(context).cancel, style: const TextStyle(color: Colors.red),),
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
                                      fixedSize: MaterialStatePropertyAll(
                                          Size(150, 40)),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Text(
                                '${requiredAmount < 0 ? translation(context).required_amount : translation(context).paid} : ${(requiredAmount != 0) ? requiredAmount.abs().toString() : ''}',
                                style: TextStyle(
                                  color: requiredAmount < 0
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Row(
                                children: [
                                  SizedBox(width: 30),
                                  // Text(
                                  //   '${isAmountPositive ? translation(context).required_amount : translation(context).paid} : ${(requiredAmount != 0) ? requiredAmount.abs().toString() : ''}',
                                  //   style: TextStyle(
                                  //     color: isAmountPositive
                                  //         ? Colors.red
                                  //         : Colors.green,
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // ),
                                  SizedBox(width: 30),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                              controller: _majorController,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
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
                          const SizedBox(height: 75),
                          const Row(
                            children: [
                              SizedBox(width: 130),

                            ],
                          ),
                          const SizedBox(height: 150),
                          Row(
                            children: [
                              const SizedBox(width: 150),
                              image != null
                                  ? Container(
                                      height: 160,
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
                          const SizedBox(height: 140),
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
                        if (_nameController.text.isNotEmpty &&
                            _lastNameController.text.isNotEmpty &&
                            regDate != null &&
                            birhtDate != null) {
                          Prof prof = Prof(
                              groups: widget.selectedProf.groups,
                              absences: [],
                              birthDate: birhtDate,
                              registrationDate: regDate,
                              firstName: _nameController.text,
                              lastName: _lastNameController.text,
                              major: _majorController.text,
                              dueAmmount: widget.selectedProf.dueAmmount,
                              registrationNumber: widget.selectedProf.registrationNumber,
                              payedAmmount: widget.selectedProf.payedAmmount,
                              id: widget.selectedProf.id,
                              image: base64Image
                          );
                          profService.update(prof);
                          Navigator.of(context).pop();
                          setState(() {
                            setAllProfs(profService.getAll(), context);
                            setFiltredProfs(profService.getAll(), context);
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
                      child: Text(
                        translation(context).save,
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w600,fontSize: 20),
                      ),
                    )
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

double getRequiredAmmount(Prof prof, context) {
  GroupService groupService = new GroupService();
  ProfService profService = new ProfService();
  double result = 0;
  for (Ammount ammount in prof.payedAmmount!) {
    result += ammount.ammount!;
  }
  for (Ammount ammount in prof.dueAmmount!) {
    result -= ammount.ammount!;
  }

  return result;
}
