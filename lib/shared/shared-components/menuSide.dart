import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/providers/userProvider.dart';
import 'package:madrasti/shared/services/schoolService.dart';
import 'package:madrasti/shared/widgets/manageAccounts/manageAccounts.dart';

import '../../models/school.dart';
import '../../models/user.dart';
import '../widgets/update/updateSchool.dart';

class MenuSide extends StatefulWidget {
  final Function(int) onItemSelected;
  const MenuSide({super.key, required this.onItemSelected});

  @override
  State<MenuSide> createState() => _MenuSideState();
}

class _MenuSideState extends State<MenuSide> {
  String? base64Image;
  Image? image;

  String? schollName;

  int _selectedIndex = -1;
  SchoolService schoolService = SchoolService();

  bool isAdmin(context) {
    User? user = getCurrentUser(context);
    return user != null && user.isAdmin == true;
  }

  bool havePermission(int index) {
    User? user = getCurrentUser(context);
    return user != null && user.permissions != null && user.permissions!.contains(index.toString());
  }

  @override
  void initState() {
    School? school = schoolService.get(0);

    if(school != null){
      setState(() {
        schollName = school.name ?? '';
        base64Image = school.image;
        image =
        base64Image != null ? Image.memory(base64Decode(base64Image!)) : null;
      });

    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 500,
          child: Center(
            child: Row(
              children: [
                const SizedBox(width: 30,),
                CircleAvatar(
                  radius: 40, // Increase this value to make the CircleAvatar bigger
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: SizedBox(
                      width: 100, // Adjust the width of the container
                      height: 160, // Adjust the height of the container
                      child: image ?? Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                SizedBox(
                  width: 70,
                    child: Text(schollName ?? '',style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildHeader(context, translation(context).home),
              _buildListTile(context, icon: Icons.home_outlined, text: translation(context).home, index: 0),
              (havePermission(1) || isAdmin(context))
                  ? _buildListTile(context, icon: Icons.calendar_month, text: translation(context).time_table, index: 1)
                  : const SizedBox(),
              const SizedBox(height: 10),
              _buildHeader(context, translation(context).overview),
              (havePermission(2) || isAdmin(context))
                  ? _buildListTile(context, icon: Icons.group_outlined, text: translation(context).students, index: 2)
                  : const SizedBox(),
              (havePermission(3) || isAdmin(context))
                  ? _buildListTile(context, icon: Icons.supervisor_account_outlined, text: translation(context).profs, index: 3)
                  : const SizedBox(),
              (havePermission(9) || isAdmin(context))
                  ? _buildListTile(context, icon: Icons.access_time_outlined, text: translation(context).attendance, index: 4)
                  : const SizedBox(),
              const SizedBox(height: 10),
              _buildHeader(context, translation(context).groups),
              (havePermission(5) || isAdmin(context))
                  ? _buildListTile(context, icon: Icons.account_tree, text: translation(context).groups, index: 5)
                  : const SizedBox(),
              (havePermission(2) || isAdmin(context))
                  ? _buildListTile(context, icon: Icons.group_outlined, text: translation(context).sudents_groups, index: 6)
                  : const SizedBox(),
              (havePermission(3) || isAdmin(context))
                  ? _buildListTile(context, icon: Icons.man, text: translation(context).profs_groups, index: 7)
                  : const SizedBox(),
              (havePermission(4) || isAdmin(context))
                  ? _buildListTile(context, icon: Icons.room, text: translation(context).rooms, index: 8)
                  : const SizedBox(),
              const SizedBox(height: 10),
              _buildHeader(context, translation(context).finance),
              (havePermission(6) || isAdmin(context))
                  ? _buildListTile(context, icon: Icons.monetization_on, text: translation(context).finance, index: 9)
                  : const SizedBox(),
              (havePermission(7) || isAdmin(context))
                  ? _buildListTile(context, icon: Icons.monetization_on_outlined, text: translation(context).expenses, index: 10)
                  : const SizedBox(),
              const SizedBox(height: 10),
              _buildHeader(context, translation(context).settings),
              (havePermission(8) || isAdmin(context))
                  ? _buildListTile(context, icon: Icons.settings, text: translation(context).settings, index: 11)
                  : const SizedBox(),
              (isAdmin(context))
                  ? _buildListTile(context, icon: Icons.manage_accounts, text: translation(context).manage_accounts, index: 12)
                  : const SizedBox(),
              _buildListTile(context, icon: Icons.support_agent, text: translation(context).tech_support, index: 13),
            ],
          ),
        ),
        const Divider(color: Colors.blueAccent, thickness: 2),
        Container(
          height: 50,
          width: 500,
          decoration: const BoxDecoration(),
          child: Center(
            child: Text(translation(context).app_version),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String text) {
    return Column(
      children: [
        Text(text),
        const Divider(),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String text, required int index}) {
    bool _isHovered = false;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return MouseRegion(
          onEnter: (_) {
            setState(() {

              _isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {

              _isHovered = false;
            });
          },
          child: ListTile(
            tileColor: _isHovered || _selectedIndex == index && ![11,12,13].contains(index)
                ? Colors.blue.withOpacity(0.9)
                : Colors.transparent, // Change the background color
            leading: Icon(icon, color: _isHovered || _selectedIndex == index && ![11,12,13].contains(index)? Colors.white : Colors.blueAccent),
            title: Text(
              text,
              style: TextStyle(color:_isHovered || _selectedIndex == index && ![11,12,13].contains(index)?Colors.white: Colors.black), // Keep text color black
            ),
            onTap: () async {
              setState(() {
                _selectedIndex = index;
              });

              if (![11, 12, 13].contains(index)) {
                widget.onItemSelected(index);
              }

              // Handle specific dialog logic for index 11, 12, 13
              if (index == 11) {
                bool? res = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const Dialog(child: UpdateSchool());
                  },
                );
                if(res != null){
                  School? school = schoolService.get(0);
                  if(school != null){
                    setState(() {
                      schollName = school.name ?? '';
                      base64Image = school.image;
                      image =
                      base64Image != null ? Image.memory(base64Decode(base64Image!)) : null;
                    });

                  }
                }
              } else if (index == 12) {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const Dialog(child: ManageAccounts());
                  },
                );
              } else if (index == 13) {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        height: 400,
                        width: 500,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(translation(context).tech_support, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
                            const SizedBox(height: 20),
                            Text(translation(context).tech_help),
                            const SizedBox(height: 30),

                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.facebook, color: Colors.blueAccent),
                                    const SizedBox(width: 5),
                                    Text(translation(context).facebook_page),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                      readOnly: true,
                                      initialValue: 'logiciel مدرستي',
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                                        border: const OutlineInputBorder(),
                                        labelText: translation(context).facebook_page,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}