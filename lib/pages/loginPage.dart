import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:madrasti/providers/userProvider.dart';
import 'package:madrasti/shared/services/schoolService.dart';
import 'package:madrasti/shared/services/userService.dart';

import '../language_utils/language_constants.dart';
import '../licance/licanceUtils.dart';
import '../models/school.dart';
import '../models/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? base64Image;
  Image? image;
  bool hidePassword = true;
  UserService userService = new UserService();
  SchoolService schoolService = new SchoolService();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String encryptedKey = '';

  String? schoolName;
  String decripted = '';
  String invalidKey='';

  void _encryptLicense() {
    LicenseUtils licenseUtils = LicenseUtils();

    // Generate a key based on the current date
    final String dateKey = licenseUtils.generateDateKey();

    // Encrypt the date-based key
    setState(() {
      encryptedKey = licenseUtils.encryptKey(dateKey);
      decripted = licenseUtils.decryptKey(encryptedKey);
    });
    print('Encrypted Key: $encryptedKey');
    print(decripted);

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
      schoolName = school.name ?? '';
    }

  }
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: SizedBox(
                height: size.height,
                  child: Image.asset('assets/loginbg.png',height: size.height,fit: BoxFit.cover),
              ),
            ),
            Positioned(
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60, right: 230),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 80, // Increase this value to make the CircleAvatar bigger
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: SizedBox(
                                width: 160, // Adjust the width of the container
                                height: 160, // Adjust the height of the container
                                child: (image != null)? image : Image.asset(
                                  'assets/logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Text(schoolName ?? '',style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                          const SizedBox(height: 40,),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF158BB0))),
                                  border: const UnderlineInputBorder(),
                                  labelText: translation(context).user_name,
                                  hintText: '',
                                  prefixIcon: const Icon(Icons.person, color: Color(0xFF158BB0),),
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
                              width: 300,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: hidePassword,
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF158BB0))),
                                  border: const UnderlineInputBorder(),
                                  labelText: translation(context).password,
                                  hintText: '',
                                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF158BB0),),
                                  suffixIcon: (hidePassword)
                                      ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        hidePassword = false;
                                      });
                                    },
                                    child: const Icon(Icons.visibility_off,color: Color(0xFF158BB0),),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        hidePassword = true;
                                      });
                                    },
                                    child: const Icon(Icons.visibility_outlined, color: Color(0xFF158BB0),),
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50,),
                          ElevatedButton(
                              onPressed: () async{
                                //_encryptLicense();
                                String userName = _nameController.text ?? '';
                                String password = _passwordController.text ?? '';
                                if(userName == 'admin' && password == 'admin'){
                                  User user = User(
                                    userName: 'admin',
                                    password: 'admin',
                                    isAdmin: true,
                                  );
                                  if(!userService.getAll().any((element) => element.userName == 'admin' && element.password == 'admin')){
                                    userService.add(user);
                                  }
                                  setCurrentUser(user, context);
                                  Navigator.of(context)
                                      .pushNamed('Home');
                                }
                                List<User> users = userService.getAll();
                                if(!users.any((element) => element.isAdmin == true && element.password != 'admin')){
                                  User user = User(
                                    userName: _nameController.text,
                                    password: _passwordController.text,
                                    isAdmin: true,
                                    permissions: [],
                                  );
                                  User createdUser = await userService.add(user);
                                  setCurrentUser(createdUser, context);
                                }else {
                                  if (users.any((element) =>
                                  element.userName == userName &&
                                      element.password == password)) {
                                    User user = users.firstWhere((element) =>
                                    element.userName == userName &&
                                        element.password == password);
                                    setCurrentUser(user, context);
                                    Navigator.of(context)
                                        .pushNamed('Home');
                                  }
                                  else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          Future.delayed(
                                              const Duration(seconds: 3), () {
                                            Navigator.of(context).pop();
                                          });
                                          return Dialog(
                                            elevation: 2,
                                            backgroundColor: Colors.red
                                                .withOpacity(0.5),
                                            child: SizedBox(
                                              height: 60,
                                              width: 400,
                                              child: Center(
                                                child: Text(
                                                  translation(context)
                                                      .login_failed,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 25),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                }
                              },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF158BB0)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60), // Adjust the radius as needed
                                ),
                              )
                            ),
                              child: Container(
                                width: 300,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  translation(context).login
                                ),
                              ),
                          )

                        ],
                      ),
                    ),

                    SizedBox(
                      height: size.height,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
