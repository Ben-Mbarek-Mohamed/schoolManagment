import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madrasti/providers/profProvider.dart';
import 'package:madrasti/shared/services/profService.dart';

import '../../../language_utils/language_constants.dart';
import '../../../models/prof.dart';

class SearchProfInGroup extends StatefulWidget {
  const SearchProfInGroup({super.key});

  @override
  State<SearchProfInGroup> createState() => _SearchProfInGroupState();
}

class _SearchProfInGroupState extends State<SearchProfInGroup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();

  ProfService profService = ProfService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: 500,
      height: 450,
      child: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Icon(
            Icons.search,
            color: Colors.blueAccent,
            size: 70,
          ),
          const SizedBox(
            height: 10,
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
                hintText: '111720557910',
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
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        List<Prof> filtredData = profService.getAll();
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
                          setFiltredProfs(filtredData, context);
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
