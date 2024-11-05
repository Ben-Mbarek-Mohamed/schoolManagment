import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/providers/profProvider.dart';
import 'package:madrasti/shared/services/profService.dart';

import '../../../language_utils/language_constants.dart';
import '../../../models/group.dart';
import '../../../models/prof.dart';
import '../../services/grouService.dart';
import '../myImagePicker.dart';

class AddProf extends StatefulWidget {
  const AddProf({super.key});

  @override
  State<AddProf> createState() => _AddProfState();
}

class _AddProfState extends State<AddProf> {
  DateTime? regDate;
  DateTime? birhtDate;
  List<Groupe>? groups = [];
  List<Groupe>? selectedGroups = [];
  String? base64Image;
  Image? image;

  GroupService groupService = GroupService();
  ProfService profService = ProfService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
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
                      "${translation(context).add_prof} :",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${translation(context).add_to_group} :',
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
                              // ElevatedButton(
                              //   onPressed: () {},
                              //   child: Row(
                              //     children: [
                              //       Icon(
                              //         Icons.done_outline_outlined,
                              //         color: Colors.white,
                              //         size: 12,
                              //       ),
                              //       SizedBox(width: 10),
                              //       Container(
                              //         width: 110,
                              //         child: Text(
                              //           translation(context)
                              //               .success_sertificate,
                              //           style: TextStyle(
                              //             color: Colors.white,
                              //             fontSize: 11,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              //   style: ButtonStyle(
                              //     elevation: MaterialStatePropertyAll(5),
                              //     fixedSize:
                              //         MaterialStatePropertyAll(Size(180, 40)),
                              //     backgroundColor:
                              //         MaterialStatePropertyAll(Colors.green),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 100),
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
                          const SizedBox(height: 120),
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
                        if (_nameController.text.isNotEmpty &&
                            _lastNameController.text.isNotEmpty &&
                            selectedGroups != null && selectedGroups!.isNotEmpty &&
                            regDate != null &&
                            birhtDate != null) {
                          Prof prof = Prof(
                            groups: (selectedGroups != null && selectedGroups!.isNotEmpty)?selectedGroups!.map((e) => e.id!).toList() : [],
                            absences: [],
                            birthDate: birhtDate,
                            registrationDate: regDate,
                            firstName: _nameController.text,
                            lastName: _lastNameController.text,
                            major: _majorController.text,
                            dueAmmount: [],
                            payedAmmount: [],
                            registrationNumber: 111720557913.toString(),
                            id: 0,
                            image: base64Image,
                          );
                          Prof prf = await profService.add(prof);
                          Navigator.of(context).pop();
                          setState(() {
                            setAllProfs(profService.getAll(), context);
                            setFiltredProfs(profService.getAll(), context);
                            if ((selectedGroups!.isNotEmpty)) {
                              for (Groupe group in selectedGroups!) {
                                group.profsId!.add('${prf.id!}?${DateTime.now()}');
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
                      child: Text(translation(context).cancel, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 20),),
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
