import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madrasti/licance/licanceUtils.dart';
import 'package:madrasti/shared/services/licenseService.dart';

import '../language_utils/language_constants.dart';
import '../language_utils/languagesWidget.dart';
import '../main.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController _keyController = new TextEditingController();

  LicenseService licenseService = new LicenseService();
  String encryptedKey = '';

  String decripted = '';
  String invalidKey = '';

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
  }

  String _decritLicense(String encrypted) {
    LicenseUtils licenseUtils = LicenseUtils();
    setState(() {
      decripted = licenseUtils.decryptKey(encrypted);
    });
    return decripted ?? '';
  }

  bool isVaildKey(String key) {
    LicenseUtils licenseUtils = LicenseUtils();
    String result = _decritLicense(key);
    if (result == '') {
      print('Decryption failed or result is empty');
      return false;
    } else {
      DateTime? dateTime = DateTime.tryParse(result);
      final dateKey = DateTime.tryParse(licenseUtils.generateDateKey());
      print(dateTime);
      print(dateKey);
      if (dateTime != null) {
        final daysRemaining = 7 - dateKey!.difference(dateTime).inDays;
        print('DateTime: $dateTime');
        print('Days Remaining: $daysRemaining');
        if (daysRemaining >= 0) {
          return true;
        } else {
          print('License key has expired');
          return false;
        }
      } else {
        print('DateTime parsing failed');
        return false;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF11A8D7),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              dropdownColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              underline: const SizedBox(),
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
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Center(
                child: Image.asset('assets/logo.png'),
              ),
            ),
            SizedBox(
              width: 600,
              child: (!licenseService.isFreeTrialEnded())
                  ? Text(translation(context).welcomeText)
                  : Center(child: Text(translation(context).free_trial_ended)),
            ),
            const SizedBox(
              height: 30,
            ),
            (licenseService.isFreeTrialStarted() && !licenseService.isFreeTrialEnded())
                ? Text(translation(context).free_trial_remainding +
                    (3 -
                            DateTime.now()
                                .difference(licenseService.getFreeTrialDate())
                                .inDays)
                        .toString())
                : const SizedBox(),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 450,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              width: 500,
                              height: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    translation(context).licence_key,
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF158BB0)),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 450,
                                    height: 50,
                                    child: TextFormField(
                                      controller: _keyController,
                                      textDirection: TextDirection.ltr,
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF158BB0))),
                                        border: const OutlineInputBorder(),
                                        labelText:
                                            translation(context).licence_key,
                                        hintText:
                                            '9wwIQGfTpqtLU0/eVJDCR/eVcCawP3Gh8WerJWRBOYL6CpYE=',
                                        prefixIcon: const Icon(
                                          Icons.key,
                                          color: Color(0xFF158BB0),
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 70,
                                  ),
                                  SizedBox(
                                    width: 400,
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            if (isVaildKey(
                                                _keyController.text.trim())) {
                                              licenseService.activate();
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      'login');
                                            } else {
                                              setState(() {
                                                _keyController.clear();
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (
                                                        BuildContext context) {
                                                      Future.delayed(
                                                          const Duration(
                                                              seconds: 3), () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                      return Dialog(
                                                        elevation: 2,
                                                        backgroundColor: Colors
                                                            .red
                                                            .withOpacity(0.5),
                                                        child: SizedBox(
                                                          height: 60,
                                                          width: 400,
                                                          child: Center(
                                                              child: Text(
                                                                translation(
                                                                    context)
                                                                    .invalid_license_key,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                    fontSize: 25),
                                                              )),
                                                        ),
                                                      );
                                                    });
                                              });
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xFF158BB0)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          60), // Adjust the radius as needed
                                                ),
                                              )),
                                          child: Text(
                                              translation(context).validate),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _encryptLicense();
                                            setState(() {
                                              invalidKey = '';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xFF158BB0)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          60), // Adjust the radius as needed
                                                ),
                                              )),
                                          child:
                                              Text(translation(context).cancel),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF158BB0)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                60), // Adjust the radius as needed
                          ),
                        )),
                    child: Container(
                      width: 150,
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(translation(context).licence_key,
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (!licenseService.isFreeTrialEnded())
                        ? () {
                            if (!licenseService.isFreeTrialEnded()) {
                              if (!licenseService.isFreeTrialStarted()) {
                                licenseService.startFreeTrial(DateTime.now());
                              }
                              Navigator.of(context)
                                  .pushReplacementNamed('login');
                            }
                          }
                        : null,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF158BB0)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                60), // Adjust the radius as needed
                          ),
                        )),
                    child: Container(
                      width: 150,
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      child: GestureDetector(
                        onLongPress: () async {
                          await Hive.deleteFromDisk();
                        },
                        child: Center(
                          child: (licenseService.isFreeTrialStarted())
                              ? Text(translation(context).login)
                              : Text(translation(context).start_free_trial),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
