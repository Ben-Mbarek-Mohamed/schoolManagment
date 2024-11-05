import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:madrasti/providers/ammountProvider.dart';
import 'package:madrasti/providers/expencesProvider.dart';
import 'package:madrasti/shared/services/ammountService.dart';
import 'package:provider/provider.dart';

import '../../../language_utils/language_constants.dart';

class SearchAmmount extends StatefulWidget {
  final bool isExpences;

  const SearchAmmount({super.key, required this.isExpences});

  @override
  State<SearchAmmount> createState() => _SearchAmmountState();
}

class _SearchAmmountState extends State<SearchAmmount> {
  DateTime? date;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ammountController = TextEditingController();

  AmmountService ammountService = AmmountService();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AmmountProvider>(context);
    var provider2 = Provider.of<ExpencesProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.4,
      height: 550,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Text(translation(context).date),
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
            const SizedBox(height: 20),
            Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (widget.isExpences) {
                          if (_nameController.text != '') {
                            List<Ammount>? filtredDate =
                                getAllExpences(context);
                            filtredDate = filtredDate!
                                .where((element) =>
                                    element.name!.toLowerCase().contains(
                                        _nameController.text.toLowerCase()) &&
                                    element.isExpence == true)
                                .toList();
                            setAllExpences(filtredDate, context);
                          }
                          if (_ammountController.text != '') {
                            List<Ammount>? filtredDate =
                                getAllExpences(context);
                            filtredDate = filtredDate!
                                .where((element) =>
                                    element.ammount! ==
                                        double.tryParse(
                                            _ammountController.text) &&
                                    element.isExpence == true)
                                .toList();
                            setAllExpences(filtredDate, context);
                          }
                          if (date != null) {
                            List<Ammount>? filtredDate =
                                getAllExpences(context);
                            filtredDate = filtredDate!
                                .where((element) =>
                                    DateFormat('yyyy-MM-dd')
                                            .format(element.date!) ==
                                        DateFormat('yyyy-MM-dd')
                                            .format(date!) &&
                                    element.isExpence == true)
                                .toList();
                            setAllExpences(filtredDate, context);
                          }
                        } else {
                          if (_nameController.text != '') {
                            List<Ammount>? filtredDate =
                                getAllAmmounts(context);
                            filtredDate = filtredDate!
                                .where((element) => element.name!
                                    .toLowerCase()
                                    .contains(
                                        _nameController.text.toLowerCase()))
                                .toList();
                            setAllAmmounts(filtredDate, context);
                          }
                          if (_ammountController.text != '') {
                            List<Ammount>? filtredDate =
                                getAllAmmounts(context);
                            filtredDate = filtredDate!
                                .where((element) =>
                                    element.ammount! ==
                                    double.tryParse(_ammountController.text))
                                .toList();
                            setAllAmmounts(filtredDate, context);
                          }
                          if (date != null) {
                            List<Ammount>? filtredDate =
                                getAllAmmounts(context);
                            filtredDate = filtredDate!
                                .where((element) =>
                                    DateFormat('yyyy-MM-dd')
                                        .format(element.date!) ==
                                    DateFormat('yyyy-MM-dd').format(date!))
                                .toList();
                            setAllAmmounts(filtredDate, context);
                          }
                        }

                        Navigator.of(context).pop();
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
          ],
        ),
      ),
    );
  }
}
