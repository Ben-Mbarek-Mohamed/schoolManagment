import 'package:flutter/material.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:madrasti/providers/ammountProvider.dart';
import 'package:madrasti/providers/expencesProvider.dart';
import 'package:madrasti/shared/services/ammountService.dart';
import 'package:provider/provider.dart';

import '../language_utils/language_constants.dart';
import 'package:flutter_charts/flutter_charts.dart';


class IncomesPage extends StatefulWidget {
  const IncomesPage({super.key});

  @override
  State<IncomesPage> createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage> {
  int index = 1;
  List<Color> colors = [Colors.green, Colors.blueAccent, Colors.red];
  AmmountService ammountService = AmmountService();
  List<Ammount> ammounts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context, ammountService);
    ammounts = ammountService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: ListView(
            children: [
              Row(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if(getAllAmmounts(context) != null){
                          ammounts = getAllAmmounts(context)!;
                        }
                        index = 1;

                      });
                    },
                    child: (isRTL)
                        ? Container(
                      width: 250,
                      height: 50,
                      decoration: (index == 1)
                          ? BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          border:
                          Border.all(width: 1, color: Colors.green),
                          color: Colors.green)
                          : BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border.all(width: 0.2),
                      ),
                      child: Center(
                        child: Text(
                          translation(context).incomes,
                          style: TextStyle(
                              color: (index == 1)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    )
                        : Container(
                      width: 250,
                      height: 50,
                      decoration: (index == 1)
                          ? BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          border:
                          Border.all(width: 1, color: Colors.green),
                          color: Colors.green)
                          : BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        border: Border.all(width: 0.2),
                      ),
                      child: Center(
                        child: Text(
                          translation(context).incomes,
                          style: TextStyle(
                              color: (index == 1)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ammounts = ammountService.getAll();
                        index = 2;
                      });
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: (index == 2)
                          ? BoxDecoration(
                          border:
                          Border.all(width: 1, color: Colors.blueAccent),
                          color: Colors.blue)
                          : BoxDecoration(
                        border: Border.all(width: 0.2),
                      ),
                      child: Center(
                        child: Text(
                          translation(context).net_profit,
                          style: TextStyle(
                              color: (index == 2) ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if(getAllExpences(context) != null){
                          ammounts = getAllExpences(context)!;
                        }
                        index = 3;

                      });
                    },
                    child: (isRTL)
                        ? Container(
                      width: 250,
                      height: 50,
                      decoration: (index == 3)
                          ? BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          border:
                          Border.all(width: 1, color: Colors.red),
                          color: Colors.red)
                          : BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        border: Border.all(width: 0.2),
                      ),
                      child: Center(
                        child: Text(
                          translation(context).expenses,
                          style: TextStyle(
                              color: (index == 3)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    )
                        : Container(
                      width: 250,
                      height: 50,
                      decoration: (index == 3)
                          ? BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          border:
                          Border.all(width: 1, color: Colors.red),
                          color: Colors.red)
                          : BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border.all(width: 0.2),
                      ),
                      child: Center(
                        child: Text(
                          translation(context).expenses,
                          style: TextStyle(
                              color: (index == 3)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: colors[index - 1], width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: info(context, colors[index - 1], index),
              ),
              const SizedBox(height: 50,),
              Text(translation(context).this_month,style: const TextStyle( fontWeight: FontWeight.w600, fontSize: 25),),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  height: 500,
                  width: 1500,
                  child: chartToRun(ammounts, context, colors[index-1], (index == 2)? true : false),
                ),
              ),
              const SizedBox(height: 50,),
              Text(translation(context).this_year,style: const TextStyle( fontWeight: FontWeight.w600, fontSize: 25),),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  height: 500,
                  width: 1500,
                  child: chartToRun2(ammounts, context, colors[index-1], (index == 2)? true : false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget? info(context, color, index) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${translation(context).today} : ${getIncomesToday(index)}',
              style: TextStyle(
                  color: (getIncomesToday(index).toString().split('-').length>1)?Colors.red:color, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text('${translation(context).last_month} : ${getIncomesLastMonth(index)}',
                style: TextStyle(
                    color: (getIncomesLastMonth(index).toString().split('-').length>1)?Colors.red:color, fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 50,
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${translation(context).this_month} : ${getIncomesThisMonth(index)}',
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text('${translation(context).last_year} : ${getIncomesLatYear(index)}',
                style: TextStyle(
                    color: (getIncomesLatYear(index).toString().split('-').length>1)?Colors.red:color, fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 50,
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${translation(context).this_year} : ${getIncomesThisYear(index)}',
              style: TextStyle(
                  color: (getIncomesThisYear(index).toString().split('-').length>1)?Colors.red:color, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text('',
                style: TextStyle(
                    color: color, fontSize: 30, fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ],
    ),
  );
}

getIncomesToday(int index) {
  AmmountService ammountService = AmmountService();
  double res = 0;
  if (index == 1) {
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == false &&
        element.date!.day == DateTime.now().day
        &&
        element.date!.month == DateTime.now().month
        &&
        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts) {
      res += ammount.ammount!;
    }
  }

  if (index == 3) {
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == true &&
        element.date!.day == DateTime.now().day
        &&
        element.date!.month == DateTime.now().month
        &&
        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts) {
      res += ammount.ammount!;

    }
  }
  if(index == 2){
    double res1 = 0;
    double res2 = 0;
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == false &&
        element.date!.day == DateTime.now().day
        &&
        element.date!.month == DateTime.now().month
        &&
        element.date!.year == DateTime.now().year
    )
        .toList();
    for (Ammount ammount in ammounts) {
      res1 += ammount.ammount!;
    }
    List<Ammount> ammounts2 = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == true &&
        element.date!.day == DateTime.now().day
        &&
        element.date!.month == DateTime.now().month
        &&
        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts2) {
      res2 += ammount.ammount!;

    }

    res = res1 - res2;
  }

  return (res == 0 )? ' _ ' :res;
}

getIncomesThisMonth(int index) {
  AmmountService ammountService = AmmountService();
  double res = 0;
  if (index == 1) {
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == false &&

        element.date!.month == DateTime.now().month
        &&
        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts) {
      res += ammount.ammount!;
    }
  }

  if (index == 3) {
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == true &&

        element.date!.month == DateTime.now().month
        &&
        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts) {
      res += ammount.ammount!;

    }
  }
  if(index == 2){
    double res1 = 0;
    double res2 = 0;
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == false &&

        element.date!.month == DateTime.now().month
        &&
        element.date!.year == DateTime.now().year
    )
        .toList();
    for (Ammount ammount in ammounts) {
      res1 += ammount.ammount!;
    }
    List<Ammount> ammounts2 = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == true &&

        element.date!.month == DateTime.now().month
        &&
        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts2) {
      res2 += ammount.ammount!;

    }

    res = res1 - res2;
  }

  return (res == 0 )? ' _ ' :res;
}

getIncomesThisYear(int index) {
  AmmountService ammountService = AmmountService();
  double res = 0;
  if (index == 1) {
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == false &&

        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts) {
      res += ammount.ammount!;
    }
  }

  if (index == 3) {
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == true &&

        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts) {
      res += ammount.ammount!;

    }
  }
  if(index == 2){
    double res1 = 0;
    double res2 = 0;
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == false &&

        element.date!.year == DateTime.now().year
    )
        .toList();
    for (Ammount ammount in ammounts) {
      res1 += ammount.ammount!;
    }
    List<Ammount> ammounts2 = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == true &&

        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts2) {
      res2 += ammount.ammount!;

    }

    res = res1 - res2;
  }

  return (res == 0 )? ' _ ' :res;
}

getIncomesLastMonth(int index) {
  AmmountService ammountService = AmmountService();
  double res = 0;
  if (index == 1) {
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == false &&

        element.date!.month == DateTime.now().month -1
        &&
        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts) {
      res += ammount.ammount!;
    }
  }

  if (index == 3) {
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == true &&

        element.date!.month == DateTime.now().month -1
        &&
        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts) {
      res += ammount.ammount!;

    }
  }
  if(index == 2){
    double res1 = 0;
    double res2 = 0;
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == false &&

        element.date!.month == DateTime.now().month - 1
        &&
        element.date!.year == DateTime.now().year
    )
        .toList();
    for (Ammount ammount in ammounts) {
      res1 += ammount.ammount!;
    }
    List<Ammount> ammounts2 = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == true &&

        element.date!.month == DateTime.now().month -1
        &&
        element.date!.year == DateTime.now().year)
        .toList();
    for (Ammount ammount in ammounts2) {
      res2 += ammount.ammount!;

    }

    res = res1 - res2;
  }

  return (res == 0 )? ' _ ' :res;
}

getIncomesLatYear(int index) {
  AmmountService ammountService = AmmountService();
  double res = 0;
  if (index == 1) {
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == false &&

        element.date!.year == DateTime.now().year -1 )
        .toList();
    for (Ammount ammount in ammounts) {
      res += ammount.ammount!;
    }
  }

  if (index == 3) {
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == true &&

        element.date!.year == DateTime.now().year -1 )
        .toList();
    for (Ammount ammount in ammounts) {
      res += ammount.ammount!;

    }
  }
  if(index == 2){
    double res1 = 0;
    double res2 = 0;
    List<Ammount> ammounts = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == false &&

        element.date!.year == DateTime.now().year -1
    )
        .toList();
    for (Ammount ammount in ammounts) {
      res1 += ammount.ammount!;
    }
    List<Ammount> ammounts2 = ammountService
        .getAll()
        .where((element) =>
    element.isExpence == true &&

        element.date!.year == DateTime.now().year - 1)
        .toList();
    for (Ammount ammount in ammounts2) {
      res2 += ammount.ammount!;

    }

    res = res1 - res2;
  }

  return (res == 0 )? ' _ ' :res;
}


Widget chartToRun(List<Ammount> ammounts, context, Color color, isNet) {
  if (ammounts.isEmpty) {
    return const Center(child: Text('_'));
  }

  // Prepare chart data
  final chartData = _prepareChartData(ammounts, context, color, isNet);

  // Define LineChartTopContainer with chart data
  var lineChartContainer = LineChartTopContainer(
    chartData: chartData,
    // Omit xContainerLabelLayoutStrategy if it's causing issues
  );

  // Create LineChart with LineChartPainter
  var lineChart = LineChart(
    painter: LineChartPainter(
      lineChartContainer: lineChartContainer,
    ),
  );

  return lineChart;
}

ChartData _prepareChartData(List<Ammount> ammounts, context, Color color, bool isNet) {
  // Define the current month and year
  DateTime now = DateTime.now();
  int month = now.month;
  int year = now.year;


  // Initialize data structures
  List<double> dailyTotals = List.generate(DateTime(year, month + 1, 0).day, (_) => 0.0);
  final daysInMonth = DateTime(year, month + 1, 0).day;

  // Generate labels for each day of the month
  List<String> dayLabels = List.generate(
    DateTime(year, month + 1, 0).day,
        (i) => '${i + 1}/$month',
  );


  // Calculate daily totals
  for (Ammount ammount in ammounts) {
    if (ammount.date != null) {
      DateTime date = ammount.date!;
      if (date.month == month && date.year == year) {
        int day = date.day;
        if(ammount.isExpence! && isNet){
          dailyTotals[day - 1] -= ammount.ammount ?? 0.0;
        }else{
          dailyTotals[day - 1] += ammount.ammount ?? 0.0;
        }

      }
    }
  }

  // Prepare chart data
  return ChartData(
    dataRowsColors: [color],
    dataRows: [dailyTotals],
    xUserLabels: dayLabels,
    dataRowsLegends: [translation(context).this_month],
    chartOptions: const ChartOptions(
      lineChartOptions: LineChartOptions(hotspotInnerRadius: 0,hotspotOuterRadius: 0),
      dataContainerOptions: DataContainerOptions(gridStepWidthPortionUsedByAtomicPresenter: 0.1)
    ),
  );
}


Widget chartToRun2(List<Ammount> ammounts, context, Color color, isNet) {
  if (ammounts.isEmpty) {
    return const Center(child: Text('_'));
  }

  // Prepare chart data
  final chartData = _prepareChartData2(ammounts, context, color, isNet);

  // Define LineChartTopContainer with chart data
  var lineChartContainer = LineChartTopContainer(
    chartData: chartData,
  );

  // Create LineChart with LineChartPainter
  var lineChart = LineChart(
    painter: LineChartPainter(
      lineChartContainer: lineChartContainer,
    ),
  );

  return lineChart;
}

ChartData _prepareChartData2(List<Ammount> ammounts, context, Color color, bool isNet) {
  // Define the current year
  DateTime now = DateTime.now();
  int year = now.year;

  // Initialize data structures for monthly totals
  List<double> monthlyTotals = List.generate(12, (_) => 0.0);

  // Generate labels for each month
  List<String> monthLabels = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',

  ];

  // Calculate monthly totals
  for (Ammount ammount in ammounts) {
    if (ammount.date != null) {
      DateTime date = ammount.date!;
      if (date.year == year) {
        int month = date.month;
        if (ammount.isExpence! && isNet) {
          monthlyTotals[month - 1] -= ammount.ammount ?? 0.0;
        } else {
          monthlyTotals[month - 1] += ammount.ammount ?? 0.0;
        }
      }
    }
  }

  // Prepare chart data
  return ChartData(
    dataRowsColors: [color],
    dataRows: [monthlyTotals],
    xUserLabels: monthLabels,
    dataRowsLegends: [translation(context).this_year],
    chartOptions: const ChartOptions(
      lineChartOptions: LineChartOptions(hotspotInnerRadius: 0, hotspotOuterRadius: 0),
      dataContainerOptions: DataContainerOptions(gridStepWidthPortionUsedByAtomicPresenter: 0.1),
    ),
  );
}

getData(context, ammountService)async{
  List<Ammount> ammounts = await ammountService.getAll().where((element) => element.isExpence == false).toList();
  setAllAmmounts(ammounts, context);
  List<Ammount> expances = await ammountService.getAll().where((element) => element.isExpence == true).toList();
  setAllExpences(expances, context);
}
