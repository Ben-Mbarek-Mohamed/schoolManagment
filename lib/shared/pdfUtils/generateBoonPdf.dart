import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/shared/services/schoolService.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/school.dart';

Future<void> generateBoonPdf(String firstName, String lastName, String ammount,
    String groupName, BuildContext cont) async {
  final pdf = pw.Document();

  SchoolService schoolService = SchoolService();
  School? school = schoolService.get(0);

  bool isArabic =
      ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')));
  // Load the Arabic font
  final ByteData arabicFontData =
      await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
  final arabicFont = pw.Font.ttf(arabicFontData);

  final ByteData defaultFontData =
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
  final defaultFont = pw.Font.ttf(defaultFontData);

  // Add a page with the card layout
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(1),
          child: pw.Container(
            child: pw.SizedBox(
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    (school != null)
                        ? pw.Row(
                      mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                        children: [
                      pw.Text(
                        school.name ?? '',
                        style: pw.TextStyle(
                          font: school.name != null &&
                              school.name!
                                  .contains(RegExp(r'[\u0600-\u06FF]'))
                              ? arabicFont
                              : null,
                          fontSize: 15,
                          
                        ),
                        textDirection: school.name!
                            .contains(RegExp(r'[\u0600-\u06FF]'))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      )
                    ])
                        : pw.SizedBox(),
                    pw.Row(
                        mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                      children: [
                        pw.Text(
                          '${translation(cont).recipt}',
                          style: ('${translation(cont).recipt}'
                              .contains(RegExp(r'[\u0600-\u06FF]')))
                              ? pw.TextStyle(
                            font: arabicFont,
                            fontSize: 15,
                          )
                              : pw.TextStyle(
                            font: defaultFont,
                            fontSize: 15,
                          ),
                          textDirection: ('${translation(cont).recipt}'
                              .contains(RegExp(r'[\u0600-\u06FF]')))
                              ? pw.TextDirection.rtl
                              : pw.TextDirection.ltr,
                        ),
                      ]
                    ),

                    pw.SizedBox(height: 20),
                    (isArabic)
                        ? pw.Row(
                      mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                        children: [
                      pw.Text(
                        '${firstName}',
                        style: ('${firstName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${firstName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                      pw.Text(' :'),
                      pw.SizedBox(width: 5),
                      pw.Text(
                        '${translation(cont).first_name}',
                        style: ('${translation(cont).first_name}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${translation(cont).first_name}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                    ])
                        : pw.Row(
                        mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                        children: [
                      pw.Text(
                        '${translation(cont).first_name}',
                        style: ('${translation(cont).first_name}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${translation(cont).first_name}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                      pw.Text(' :'),
                      pw.SizedBox(width: 5),
                      pw.Text(
                        '${firstName}',
                        style: ('${firstName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${firstName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                    ]),
                    (isArabic)
                        ? pw.Row(
                        mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                        children: [
                      pw.Text(
                        '${lastName}',
                        style: ('${lastName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${lastName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                      pw.Text(' :'),
                      pw.SizedBox(width: 5),
                      pw.Text(
                        '${translation(cont).last_name}',
                        style: ('${translation(cont).last_name}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${translation(cont).last_name}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                    ])
                        : pw.Row(
                        mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                        children: [
                      pw.Text(
                        '${translation(cont).last_name}',
                        style: ('${translation(cont).last_name}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${translation(cont).last_name}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                      pw.Text(' :'),
                      pw.SizedBox(width: 5),
                      pw.Text(
                        '${lastName}',
                        style: ('${lastName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${lastName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                    ]),
                    (isArabic)
                        ? pw.Row(
                        mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                        children: [
                          pw.Text(
                            '${ammount}',
                            style: ('${ammount}'
                                .contains(RegExp(r'[\u0600-\u06FF]')))
                                ? pw.TextStyle(
                              font: arabicFont,
                              fontSize: 12,
                            )
                                : pw.TextStyle(
                              font: defaultFont,
                              fontSize: 12,
                            ),
                            textDirection: ('${ammount}'
                                .contains(RegExp(r'[\u0600-\u06FF]')))
                                ? pw.TextDirection.rtl
                                : pw.TextDirection.ltr,
                          ),
                          pw.Text(' :'),
                          pw.SizedBox(width: 5),
                          pw.Text(
                            '${translation(cont).ammount}',
                            style: ('${translation(cont).ammount}'
                                .contains(RegExp(r'[\u0600-\u06FF]')))
                                ? pw.TextStyle(
                              font: arabicFont,
                              fontSize: 12,
                            )
                                : pw.TextStyle(
                              font: defaultFont,
                              fontSize: 12,
                            ),
                            textDirection: ('${translation(cont).ammount}'
                                .contains(RegExp(r'[\u0600-\u06FF]')))
                                ? pw.TextDirection.rtl
                                : pw.TextDirection.ltr,
                          ),
                        ])
                        : pw.Row(
                        mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                        children: [
                          pw.Text(
                            '${translation(cont).ammount}',
                            style: ('${translation(cont).ammount}'
                                .contains(RegExp(r'[\u0600-\u06FF]')))
                                ? pw.TextStyle(
                              font: arabicFont,
                              fontSize: 12,
                            )
                                : pw.TextStyle(
                              font: defaultFont,
                              fontSize: 12,
                            ),
                            textDirection: ('${translation(cont).ammount}'
                                .contains(RegExp(r'[\u0600-\u06FF]')))
                                ? pw.TextDirection.rtl
                                : pw.TextDirection.ltr,
                          ),
                          pw.Text(' :'),
                          pw.SizedBox(width: 5),
                          pw.Text(
                            '${ammount}',
                            style: ('${ammount}'
                                .contains(RegExp(r'[\u0600-\u06FF]')))
                                ? pw.TextStyle(
                              font: arabicFont,
                              fontSize: 12,
                            )
                                : pw.TextStyle(
                              font: defaultFont,
                              fontSize: 12,
                            ),
                            textDirection: ('${ammount}'
                                .contains(RegExp(r'[\u0600-\u06FF]')))
                                ? pw.TextDirection.rtl
                                : pw.TextDirection.ltr,
                          ),
                        ]),
                    (isArabic)
                        ? pw.Row(
                        mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                        children: [
                      pw.Text(
                        '${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                        style: ('${DateTime.now()}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          //font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          //font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${DateTime.now()}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                      pw.Text(' :'),
                      pw.SizedBox(width: 5),
                      pw.Text(
                        '${translation(cont).date}',
                        style: ('${translation(cont).date}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${translation(cont).date}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                    ])
                        : pw.Row(
                        mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                        children: [
                      pw.Text(
                        '${translation(cont).date}',
                        style: ('${translation(cont).date}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          fontSize: 12,
                        ),
                        textDirection: ('${translation(cont).date}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                      pw.Text(' :'),
                      pw.SizedBox(width: 5),
                      pw.Text(
                        '${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                        style: ('${DateTime.now()}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${DateTime.now()}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                    ]),
                    (isArabic)
                        ? pw.Row(
                        mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                        children: [
                      pw.Text(
                        '${groupName}',
                        style: ('${groupName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${groupName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                      pw.Text(' :'),
                      pw.SizedBox(width: 5),
                      pw.Text(
                        '${translation(cont).group}',
                        style: ('${translation(cont).group}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${translation(cont).group}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                    ])
                        : pw.Row(
                        mainAxisAlignment: (isArabic)?pw.MainAxisAlignment.end:pw.MainAxisAlignment.start,
                        children: [
                      pw.Text(
                        '${translation(cont).group}',
                        style: ('${translation(cont).group}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${translation(cont).group}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                      pw.Text(' :'),
                      pw.SizedBox(width: 5),
                      pw.Text(
                        '${groupName}',
                        style: ('${groupName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        )
                            : pw.TextStyle(
                          font: defaultFont,
                          fontSize: 12,
                        ),
                        textDirection: ('${groupName}'
                            .contains(RegExp(r'[\u0600-\u06FF]')))
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                      ),
                    ]),
                    pw.SizedBox(width: 5),
                  ]),
            )
          ),
        );
      },
    ),
  );

  // Print the PDF directly
  try {
    // Get a temporary directory to store the PDF temporarily
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/madrasati.pdf';

    // Write the PDF to the temp file
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Open the generated PDF
    await OpenFilex.open(filePath);
  } catch (e) {
    ScaffoldMessenger.of(cont).showSnackBar(
      SnackBar(content: Text('Error opening PDF: $e')),
    );
  }
}
