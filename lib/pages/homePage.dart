import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/models/notification.dart';
import 'package:madrasti/shared/services/grouService.dart';
import 'package:madrasti/shared/services/notificationService.dart';
import 'package:madrasti/shared/services/profService.dart';
import 'package:madrasti/shared/services/roomServices.dart';
import 'package:madrasti/shared/services/studentService.dart';
import 'package:madrasti/shared/shared-components/infoCard.dart';

import '../models/ammount.dart';
import '../models/user.dart';
import '../providers/userProvider.dart';
import '../shared/services/ammountService.dart';

class HomePage extends StatefulWidget {
  final Function(int) onItemSelected;

  const HomePage({super.key, required this.onItemSelected});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GroupService groupService = GroupService();
  StudentService studentService = StudentService();
  ProfService profService = ProfService();
  RoomService roomService = RoomService();
  NotificationService notificationService = NotificationService();
  String currentNotificationFilter = '';
  List<NotificationModel> notifications = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      currentNotificationFilter = translation(context).today;
      notifications = notificationService.getAll() ?? [];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifications = notificationService.getAll() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    List<String> notificationsDates = [
      translation(context).today,
      translation(context).this_month,
      translation(context).last_month,
      translation(context).this_year,
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: size.width * 0.79,
          height: size.height * 0.89,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Container(
                    height: 500,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.blueAccent.withOpacity(0.1))
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.notifications_active_outlined,
                                  color: Colors.black, size: 30),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                translation(context).notifications,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              DropdownButton<String>(
                                onChanged: (val) {
                                  setState(() {
                                    currentNotificationFilter = val!;
                                  });
                                },
                                hint: (currentNotificationFilter.isEmpty)
                                    ? Text(notificationsDates.first)
                                    : Text(currentNotificationFilter),
                                items: notificationsDates
                                    .map<DropdownMenuItem<String>>(
                                      (e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Text(
                                              e,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            ],
                          ),
                          const Divider(color: Colors.purpleAccent),
                          SizedBox(
                            height: 380,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int i) {
                                NotificationModel notif = notifications[i];
                                if (currentNotificationFilter ==
                                    translation(context).today) {
                                  if (notif.date!.day != DateTime.now().day ||
                                      notif.date!.month !=
                                          DateTime.now().month ||
                                      notif.date!.year != DateTime.now().year) {
                                    return Container();
                                  }
                                }
                                if (currentNotificationFilter ==
                                    translation(context).this_month) {
                                  if (notif.date!.month !=
                                          DateTime.now().month ||
                                      notif.date!.year != DateTime.now().year) {
                                    return Container();
                                  }
                                }
                                if (currentNotificationFilter ==
                                    translation(context).last_month) {
                                  if (notif.date!.month !=
                                          DateTime.now().month - 1 ||
                                      notif.date!.year != DateTime.now().year) {
                                    return Container();
                                  }
                                }
                                if (currentNotificationFilter ==
                                    translation(context).last_year) {
                                  if (notif.date!.month !=
                                          DateTime.now().month ||
                                      notif.date!.year !=
                                          DateTime.now().year - 1) {
                                    return Container();
                                  }
                                }
                                if (notif.isStudent!) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('yyyy-MM-dd')
                                            .format(notif.date!),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('${translation(context).the_student} ${notif.name} ${translation(context).should_pay} ${notif.ammount.toString()}'),
                                      const Divider(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('yyyy-MM-dd')
                                            .format(notif.date!),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('${translation(context).the_teacher}   ${notif.name}  ${translation(context).should_get} ${notif.ammount.toString()}'),
                                      const Divider(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                }
                              },
                              itemCount: notifications.length,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InfoCard(
                          index: 2,
                          color: Colors.blueAccent.withOpacity(0.5),
                          title: translation(context).students,
                          onTap: () {
                            if(havePermission(2, context)) {
                              widget.onItemSelected(2);
                            }
                          },
                          iconData: Icons.supervisor_account_outlined,
                          value: studentService.getAll().length.toString(),
                          isActive: false,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InfoCard(
                          index: 3,
                          color: Colors.teal.withOpacity(0.5),
                          title: translation(context).profs,
                          onTap: () {
                            if (havePermission(3, context)) {
                              widget.onItemSelected(3);
                            }
                          },
                          iconData: Icons.perm_identity,
                          value: profService.getAll().length.toString(),
                          isActive: false,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InfoCard(
                          index: 5,
                          color: Colors.pinkAccent.withOpacity(0.4),
                          title: translation(context).groups,
                          onTap: () {
                            if (havePermission(5, context)) {
                              widget.onItemSelected(5);
                            }
                          },
                          iconData: Icons.groups_outlined,
                          value: groupService.getAll().length.toString(),
                          isActive: false,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InfoCard(
                          index: 4,
                          color: Colors.deepPurpleAccent.withOpacity(0.4),
                          title: translation(context).rooms,
                          onTap: () {
                            if (havePermission(4, context)) {
                              widget.onItemSelected(8);
                            }
                          },
                          iconData: Icons.roofing,
                          value: roomService.getAll().length.toString(),
                          isActive: false,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InfoCard(
                      index: 6,
                      color: Colors.red.withOpacity(0.4),
                      title: translation(context).finance,
                      onTap: () {
                        if (havePermission(6, context)) {
                          widget.onItemSelected(9);
                        }
                      },
                      iconData: Icons.money,
                      subTitle: translation(context).incomes_this_moth,
                      value: getIncomesThisMonth().toString(),
                      isActive: false,
                      widh: 570,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

getIncomesThisMonth() {
  AmmountService ammountService = AmmountService();
  double res = 0;

  List<Ammount> ammounts = ammountService
      .getAll()
      .where((element) =>
          element.isExpence == false &&
          element.date!.month == DateTime.now().month &&
          element.date!.year == DateTime.now().year)
      .toList();
  for (Ammount ammount in ammounts) {
    res += ammount.ammount!;
  }

  return (res == 0) ? ' _ ' : res;
}

bool havePermission(int index, context) {
  User? user = getCurrentUser(context);
  if (user != null) {
    if(user.isAdmin == true){
      return true;
    }
    if (user.permissions != null) {
      if (user.permissions!.contains(index.toString())) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return false;
  }
}
