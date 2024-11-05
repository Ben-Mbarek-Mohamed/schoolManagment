import 'package:flutter/material.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/pages/attendencePage.dart';
import 'package:madrasti/pages/expencesPage.dart';
import 'package:madrasti/pages/groupsPage.dart';
import 'package:madrasti/pages/homePage.dart';
import 'package:madrasti/pages/incomesPage.dart';
import 'package:madrasti/pages/profPage.dart';
import 'package:madrasti/pages/profsInGroupPage.dart';
import 'package:madrasti/pages/roomPage.dart';
import 'package:madrasti/pages/studentsGroupePage.dart';
import 'package:madrasti/pages/studentsPage.dart';
import 'package:madrasti/pages/timeTablePage.dart';
import 'package:madrasti/shared/shared-components/customAppBar.dart';
import '../shared/shared-components/menuSide.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  FocusNode _focusNode = FocusNode();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);

    if(index == 4){
    }
    if(index != 4) {

      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();  // Dispose of the FocusNode
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() {
      if (_selectedIndex == 4 && !_focusNode.hasFocus) {
        // Request focus if on Attendance page and it loses focus
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_focusNode.canRequestFocus) {
            _focusNode.requestFocus();
          }
        });
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    final List<String> pageTitles = [
      translation(context).home,
      translation(context).time_table,
      translation(context).students,
      translation(context).profs,
      translation(context).attendance,
      translation(context).groups,
      translation(context).sudents_groups,
      translation(context).profs_groups,
      translation(context).rooms,
      translation(context).finance,
      translation(context).expenses,
      translation(context).settings,
      translation(context).manage_accounts,
      translation(context).tech_support,
    ];
    return WillPopScope(
      onWillPop: () async {
        return false; // Disable back button
      },
      child: Scaffold(
        appBar: CustomAppBar( titre: pageTitles[_selectedIndex],),
        body: Row(
          children: [
            SizedBox(
              width: 250, // Width of the sidebar
              child: MenuSide(onItemSelected: _onItemTapped),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),  // Disable swipe navigation
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  HomePage(onItemSelected: _onItemTapped),
                  const TimeTablePage(),
                  const StudentsPage(),
                  const ProfPage(),
                  AttendencePage(focusNode: _focusNode),
                  const GroupePage(),
                  const StudentsInGroupPage(),
                  const ProfsInGroupPage(),
                  const RoomPage(),
                  const IncomesPage(),
                  const ExpencesPage(),
                   // Placeholder for Tech Support
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
