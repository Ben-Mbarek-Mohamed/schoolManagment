import 'package:flutter/material.dart';
import 'package:madrasti/pages/schedule.dart';

import '../models/lesson.dart';


class TimeTablePage extends StatelessWidget {
  const TimeTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: size.width * 0.79,
          height: size.height * 0.90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ScheduleTable(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// Widget _getSchedule(List<Lesson> lessons){
//   return sfC;
// }