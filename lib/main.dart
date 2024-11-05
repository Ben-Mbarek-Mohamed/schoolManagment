import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:madrasti/models/attendance.dart';
import 'package:madrasti/models/group.dart';
import 'package:madrasti/models/lesson.dart';
import 'package:madrasti/models/notification.dart';
import 'package:madrasti/models/prof.dart';
import 'package:madrasti/models/room.dart';
import 'package:madrasti/models/schedule.dart';
import 'package:madrasti/models/school.dart';
import 'package:madrasti/models/sessionTime.dart';
import 'package:madrasti/models/student.dart';
import 'package:madrasti/pages/attendencePage.dart';
import 'package:madrasti/pages/loginPage.dart';
import 'package:madrasti/pages/mainScreen.dart';
import 'package:madrasti/pages/profPage.dart';
import 'package:madrasti/pages/studentsPage.dart';
import 'package:madrasti/pages/welcomePage.dart';
import 'package:madrasti/providers/ammountProvider.dart';
import 'package:madrasti/providers/attendanceProvider.dart';
import 'package:madrasti/providers/expencesProvider.dart';
import 'package:madrasti/providers/groupProvider.dart';
import 'package:madrasti/providers/profProvider.dart';
import 'package:madrasti/providers/roomProvider.dart';
import 'package:madrasti/providers/studentProvider.dart';
import 'package:madrasti/providers/userProvider.dart';
import 'package:madrasti/shared/services/licenseService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language_utils/language_constants.dart';
import 'models/color_adapter.dart';
import 'models/time_of_day_adapter.dart';
import 'models/user.dart';

void main() async {
  await Hive.deleteFromDisk();
  var prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();

  Directory appDocDir = await getApplicationDocumentsDirectory();
  // Create a path for the 'databases' folder
  String hiveDbPath = '${appDocDir.path}/madrasati_databases';

  // Initialize Hive with the specific directory
  await Hive.initFlutter(hiveDbPath);

  Hive.registerAdapter(GroupeAdapter());
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(ProfAdapter());
  Hive.registerAdapter(SessionTimeAdapter());
  Hive.registerAdapter(AmmountAdapter());
  Hive.registerAdapter(RoomAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(AttendanceAdapter());
  Hive.registerAdapter(LessonAdapter());
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(NotificationModelAdapter());
  Hive.registerAdapter(SchoolAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<Groupe>('groups',
      compactionStrategy: (entries, deletedEntries) {
    return deletedEntries > 50;
  });
  await Hive.openBox<Student>('students',
      compactionStrategy: (entries, deletedEntries) {
    return deletedEntries > 50;
  });
  await Hive.openBox<Prof>('teachers',
      compactionStrategy: (entries, deletedEntries) {
    return deletedEntries > 50;
  });
  await Hive.openBox<Room>('rooms',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 50;
      });
  await Hive.openBox<Ammount>('ammounts',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 50;
      });
  await Hive.openBox<Attendance>('attendances',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 50;
      });
  await Hive.openBox<Schedule>('schedules',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 50;
      });
  await Hive.openBox<NotificationModel>('notifications',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 50;
      });
  await Hive.openBox<School>('school',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 50;
      });
  await Hive.openBox<User>('users',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 50;
      });
  await Hive.openBox<DateTime>('free_trial',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 50;
      });
  await Hive.openBox<bool>('activated',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 50;
      });




  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_)=>GroupProvider()),
            ChangeNotifierProvider(create: (_)=>StudentProvider()),
            ChangeNotifierProvider(create: (_)=>ProfProvider()),
            ChangeNotifierProvider(create: (_)=>RoomProvider()),
            ChangeNotifierProvider(create: (_)=>AmmountProvider()),
            ChangeNotifierProvider(create: (_)=>ExpencesProvider()),
            ChangeNotifierProvider(create: (_)=>AttendanceProvider()),
            ChangeNotifierProvider(create: (_)=>UserProvider()),
          ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  LicenseService licenseService = new LicenseService();

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    int lanhguageIndex = 2;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      //this will be provided by the providerData
      home: (licenseService.isActivated())?Login():WelcomePage(),
      routes: {
        'Home': (context) => MainScreen(),
        'Welcome': (context) => WelcomePage(),
        'Students': (context) => StudentsPage(),
        'Profs': (context) => ProfPage(),
        'login': (context) => Login(),
      },
    );
  }
}
