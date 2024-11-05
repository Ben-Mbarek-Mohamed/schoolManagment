import 'package:flutter/material.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/models/user.dart';
import 'package:madrasti/shared/services/userService.dart';

class UpdateAccount extends StatefulWidget {
  final User? user;

  const UpdateAccount({super.key, this.user});

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  bool hidePassword = true;
  List<String> permissions = [];
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  UserService userService = new UserService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.userName ?? '';
      _passwordController.text = widget.user!.password ?? '';
      permissions = widget.user!.permissions ?? [];
    }
  }
  bool isAdmin(){
    if(widget.user != null){
      if(widget.user!.isAdmin == true){
        return true;
      }
      else{
        return false;
      }
    }
    else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (!isAdmin())?570 : 380,
      width: 700,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (widget.user == null)
                ? translation(context).add
                : translation(context).info,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 600,
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                  border: OutlineInputBorder(),
                  labelText: translation(context).user_name,
                  hintText: '',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 600,
              child: TextFormField(
                controller: _passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                  border: OutlineInputBorder(),
                  labelText: translation(context).password,
                  hintText: '',
                  suffixIcon: (hidePassword)
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              hidePassword = false;
                            });
                          },
                          child: Icon(Icons.visibility_off),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              hidePassword = true;
                            });
                          },
                          child: Icon(Icons.visibility_outlined),
                        ),
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (!isAdmin())?Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(translation(context).permissions + ' : ',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
          ): SizedBox(height: 1,),
          (!isAdmin())?Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                        value: permissions.contains('1'),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              permissions.add('1');
                            } else {
                              permissions.remove('1');
                            }
                          });
                        }),
                    Text(translation(context).time_table),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: permissions.contains('2'),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              permissions.add('2');
                            } else {
                              permissions.remove('2');
                            }
                          });
                        }),
                    Text(translation(context).students),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: permissions.contains('3'),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              permissions.add('3');
                            } else {
                              permissions.remove('3');
                            }
                          });
                        }),
                    Text(translation(context).profs),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: permissions.contains('4'),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              permissions.add('4');
                            } else {
                              permissions.remove('4');
                            }
                          });
                        }),
                    Text(translation(context).rooms),
                  ],
                ),
              ],
            ),
          ): SizedBox(height: 1,),
          (!isAdmin())?SizedBox(
            height: 10,
          ): SizedBox(height: 1,),
          (!isAdmin())?Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                        value: permissions.contains('5'),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              permissions.add('5');
                            } else {
                              permissions.remove('5');
                            }
                          });
                        }),
                    Text(translation(context).groups),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: permissions.contains('6'),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              permissions.add('6');
                            } else {
                              permissions.remove('6');
                            }
                          });
                        }),
                    Text(translation(context).finance),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: permissions.contains('7'),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              permissions.add('7');
                            } else {
                              permissions.remove('7');
                            }
                          });
                        }),
                    Text(translation(context).expenses),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: permissions.contains('8'),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              permissions.add('8');
                            } else {
                              permissions.remove('8');
                            }
                          });
                        }),
                    Text(translation(context).settings),
                  ],
                ),
              ],
            ),
          ): SizedBox(height: 1,),
          (!isAdmin())?SizedBox(
            height: 10,
          ): SizedBox(height: 1,),
          (!isAdmin())?Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Checkbox(
                    value: permissions.contains('9'),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          permissions.add('9');
                        } else {
                          permissions.remove('9');
                        }
                      });
                    }),
                Text(translation(context).attendance),
              ],
            ),
          ): SizedBox(height: 1,),
          (!isAdmin())?SizedBox(height: 20): SizedBox(height: 1,),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (_nameController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          if (widget.user == null) {
                            User user = User(
                                id: 0,
                                userName: _nameController.text,
                                password: _passwordController.text,
                                isAdmin: false,
                                permissions: permissions);

                            userService.add(user);
                          }
                          else{
                            User user = User(
                              id: widget.user!.id!,
                                userName: _nameController.text,
                                password: _passwordController.text,
                                isAdmin: widget.user!.isAdmin,
                                permissions: permissions);
                            userService.update(user);
                          }
                          Navigator.of(context).pop(true);
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                Future.delayed(Duration(seconds: 3), () {
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
                                        style: TextStyle(
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
                      icon: Icon(
                        Icons.done,
                        color: Colors.green,
                        size: 35,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      translation(context).save,
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      translation(context).cancel,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
