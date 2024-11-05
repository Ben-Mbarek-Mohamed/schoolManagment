import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../language_utils/language_constants.dart';
import '../../../models/student.dart';
import '../../../providers/studentProvider.dart';
import '../../services/studentService.dart';

class SearchStudentInGroup extends StatefulWidget {
  const SearchStudentInGroup({super.key});

  @override
  State<SearchStudentInGroup> createState() => _SearchStudentInGroupState();
}

class _SearchStudentInGroupState extends State<SearchStudentInGroup> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();

  StudentService studentService = StudentService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 500,
      height: 450,
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              controller: _numController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                border: const OutlineInputBorder(),
                labelText: translation(context).reg_number,
                hintText: '1720557910',
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
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
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        List<Student> filtredData = studentService.getAll();
                        if (_nameController.text.isNotEmpty) {
                          filtredData = await filtredData
                              .where((element) => element.firstName!
                              .toLowerCase()
                              .contains(_nameController.text.toLowerCase()))
                              .toList();
                        }
                        if (_lastNameController.text.isNotEmpty) {
                          filtredData = await filtredData
                              .where((element) => element.lastName!
                              .toLowerCase()
                              .contains(_lastNameController.text.toLowerCase()))
                              .toList();
                        }
                        if (_numController.text.isNotEmpty) {
                          filtredData = await filtredData
                              .where((element) => element.registrationNumber!
                              .toLowerCase()
                              .contains(_numController.text.toLowerCase()))
                              .toList();
                        }
                        setState(() {
                          setFiltredStudents(filtredData, context);
                          Navigator.of(context).pop();
                        });
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
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
