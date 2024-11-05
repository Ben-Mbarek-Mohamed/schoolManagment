import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:madrasti/providers/ammountProvider.dart';
import 'package:madrasti/providers/expencesProvider.dart';
import 'package:madrasti/shared/services/ammountService.dart';

import '../../../language_utils/language_constants.dart';

class AddAmmount extends StatefulWidget {
  final bool isExpences;
  const AddAmmount({super.key, required this.isExpences});

  @override
  State<AddAmmount> createState() => _AddAmmountState();
}

class _AddAmmountState extends State<AddAmmount> {

  DateTime? date = DateTime.now();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ammountController = TextEditingController();

  AmmountService ammountService = AmmountService();

  @override

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.6,
      height: 540,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(

          children: [

            Text(
            (widget.isExpences)?'${translation(context).add} ${translation(context).expenses} :':'${translation(context).add} ${translation(context).incomes} :',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
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
                    style: const ButtonStyle(
                      backgroundColor:
                      MaterialStatePropertyAll(Colors.blueAccent),
                      fixedSize: MaterialStatePropertyAll(Size(150, 40)),
                      elevation: MaterialStatePropertyAll(5),
                    ),
                    child: Text(
                      (date == null)
                          ? translation(context).select_date
                          : DateFormat('yyyy-MM-dd').format(date!),
                      style: const TextStyle(color: Colors.white),
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
                          date: date,
                          ammount: double.tryParse(_ammountController.text),
                          name: _nameController.text,
                          isExpence: widget.isExpences,
                        );
                        ammountService.add(ammount);
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
                      child: Text(translation(context).save, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600,fontSize: 20),),
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
                      child: Text(translation(context).cancel, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600,fontSize: 20),)
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
