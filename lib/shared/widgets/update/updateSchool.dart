import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/shared/services/schoolService.dart';

import '../../../models/school.dart';
import '../myImagePicker.dart';

class UpdateSchool extends StatefulWidget {
  const UpdateSchool({super.key});

  @override
  State<UpdateSchool> createState() => _UpdateSchoolState();
}

class _UpdateSchoolState extends State<UpdateSchool> {

  String? base64Image;
  Image? image;


  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _mailController = new TextEditingController();
  TextEditingController _siteController = new TextEditingController();

  SchoolService schoolService = new SchoolService();


  void onImageSelected(String base64, Image img) {
    setState(() {
      base64Image = base64;
      image = img;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    School? school = schoolService.get(0);
    if(school != null){
      base64Image = school.image;
      image =
      base64Image != null ? Image.memory(base64Decode(base64Image!)) : null;
      _nameController.text = school.name ?? '';
      _addressController.text = school.address ?? '';
      _mailController.text = school.email ?? '';
      _phoneController.text = school.phone ?? '';
      _siteController.text = school.webSite ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 800,
      height: 700,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(translation(context).settings, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
                const SizedBox(),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 480,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent)),
                            border: const OutlineInputBorder(),
                            labelText: translation(context).school_name,
                            hintText: '',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 480,
                        child: TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent)),
                            border: const OutlineInputBorder(),
                            labelText: translation(context).address,
                            hintText: '',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30,right: 30,left: 30),
                  child: Row(
                    children: [
                      image != null
                          ? SizedBox(
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
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 740,
                child: TextFormField(
                  controller: _phoneController,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .allow(RegExp(
                        r'^\d*\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent)),
                    border: const OutlineInputBorder(),
                    labelText: translation(context).phone_num,
                    hintText: '',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 740,
                child: TextFormField(
                  controller: _mailController,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent)),
                    border: const OutlineInputBorder(),
                    labelText: translation(context).email,
                    hintText: '',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 740,
                child: TextFormField(
                  controller: _siteController,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent)),
                    border: const OutlineInputBorder(),
                    labelText: translation(context).website,
                    hintText: '',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          School school = School(
                            id: 0,
                            name: _nameController.text,
                            image: base64Image,
                            phone: _phoneController.text,
                            email: _mailController.text,
                            address: _addressController.text,
                            webSite: _siteController.text
                          );
                          schoolService.update(0, school);
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          translation(context).save,
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w600, fontSize: 20),
                        ),
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
                          Navigator.of(context).pop(true);
                        },
                         child: Text(
                            translation(context).cancel,
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w600,fontSize: 20),
                          )
                      ),
                      const SizedBox(
                        height: 10,
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
  }
}
