import 'package:flutter/material.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/shared/services/userService.dart';
import 'package:madrasti/shared/widgets/manageAccounts/UpdateAccount.dart';

import '../../../models/user.dart';

class ManageAccounts extends StatefulWidget {
  const ManageAccounts({super.key});

  @override
  State<ManageAccounts> createState() => _ManageAccountsState();
}

class _ManageAccountsState extends State<ManageAccounts> {
  List<User> users = [];
  UserService userService = new UserService();
  User? admin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users = userService.getAll() ?? [];
    if(users.any((element) => element.isAdmin == true)){
      if(users.any((element) => element.isAdmin == true && element.password != 'admin' && element.userName != 'admin')){
        User ad = users.firstWhere((element) => element.isAdmin == true && element.password != 'admin' && element.userName != 'admin');
        admin = ad;
      }
      else{
        User user = User(
          userName: '',
          password: '',
          isAdmin: true,
          permissions: []
        );
        admin = user;
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      width: 800,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translation(context).manage_accounts,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                ),
                SizedBox(),
                ElevatedButton(
                  onPressed: () async {
                    bool? result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Dialog(
                              child: UpdateAccount(),
                            );
                          },
                        );
                      },
                    );
                    if (result == true) {
                      setState(() {
                        users = userService.getAll();
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 90,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translation(context).add,
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                translation(context).admin_account,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 100,
              width: 700,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueAccent, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (admin != null)? admin!.userName! : '',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool? result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return Dialog(
                                child: UpdateAccount(user: admin!,),
                              );
                            },
                          );
                        },
                      );
                      if (result == true) {
                        setState(() {
                          users = userService.getAll();
                        });
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 210,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translation(context).more_info,
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            Icon(
                              Icons.open_in_new,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                translation(context).other_accounts,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 300,
              child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int i) {
                      User user = users[i];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (user.isAdmin != true) ?Container(
                            height: 100,
                            width: 700,
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.blueAccent, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  user.userName ?? '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        userService.delete(user.id!);
                                        setState(() {
                                          users.remove(user);
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 110,
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                translation(context).delete,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                              Icon(
                                                Icons.delete_forever_outlined,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      style:  ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(Colors.redAccent.withOpacity(0.8)),
                                        fixedSize: MaterialStatePropertyAll(Size(150, 40)),
                                        elevation: MaterialStatePropertyAll(5),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool? result = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder:
                                                  (BuildContext context, StateSetter setState) {
                                                return Dialog(
                                                  child: UpdateAccount(user: user!,),
                                                );
                                              },
                                            );
                                          },
                                        );
                                        if (result == true) {
                                          setState(() {
                                            users = userService.getAll();
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 120,
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                translation(context).info,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Icon(
                                                Icons.open_in_new,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ): SizedBox(height: 1,),
                          (user.isAdmin != true) ?SizedBox(
                            height: 10,
                          ): SizedBox(height: 1,),
                        ],
                      );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
