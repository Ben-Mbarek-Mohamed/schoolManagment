import 'package:flutter/material.dart';
import 'package:madrasti/providers/userProvider.dart';

import '../../language_utils/language_constants.dart';
import '../../language_utils/languagesWidget.dart';
import '../../main.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String titre;

  const CustomAppBar({super.key, required this.titre});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      automaticallyImplyLeading: false,
        title: Row(
          children: [

            SizedBox(
              width: size.width * 0.4,
            ),
            Center(
              child: Text(
                widget.titre,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
              ),
            ),
          ],
        ), // Use widget.titre for dynamic title
        actions: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              dropdownColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20),
              underline: SizedBox(),
              hint: Text(translation(context).languages),
              onChanged: (Language? language) async {
                if (language != null) {
                  Locale _local = await setLocale(language.code);
                  MyApp.setLocale(context, _local);
                }
              },
              items: Language.languagesList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.flag,
                            style: const TextStyle(fontSize: 30),
                          ),
                          Text(e.name)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.3)),
                  side: MaterialStateProperty.all(BorderSide(color: Colors.red))
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('login');

              },
              child: (getCurrentUser(context) != null)?
              Text(translation(context).logout + ' (${getCurrentUser(context)!.userName})',style: TextStyle(color: Colors.red),):
              Text(translation(context).logout ,style: TextStyle(color: Colors.red),),
            ),
          ),
        ],
        shadowColor: Colors.black12,
        backgroundColor: Color(0xFF11A8D7));
  }
}
