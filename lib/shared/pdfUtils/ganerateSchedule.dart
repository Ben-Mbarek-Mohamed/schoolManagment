import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import '../../models/lesson.dart';

Future<void> generateSchedulePdf(
    List<Lesson> lessons,
    BuildContext cont,
    ) async {
  final pdf = pw.Document();

  // Load the Arabic font
  final ByteData arabicFontData = await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
  final arabicFont = pw.Font.ttf(arabicFontData);

  // Define headers and time slots
  List<String> days = [
    translation(cont).monday,
    translation(cont).tuesday,
    translation(cont).wednesday,
    translation(cont).thursday,
    translation(cont).friday,
    translation(cont).saturday,
    translation(cont).sunday
  ];
  List<String> timeSlots = [
    "08:00 - 09:00", "09:00 - 10:00", "10:00 - 11:00", "11:00 - 12:00", "12:00 - 13:00",
    "13:00 - 14:00", "14:00 - 15:00", "15:00 - 16:00", "16:00 - 17:00", "17:00 - 18:00",
    "18:00 - 19:00", "19:00 - 20:00", "20:00 - 21:00"
  ];

  // Helper function to check if a string contains Arabic characters
  bool _isArabic(String text) {
    return text.contains(RegExp(r'[\u0600-\u06FF]'));
  }

  // Create the PDF content
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Padding(
          padding: pw.EdgeInsets.all(1),
          child: pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Table Header
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(),
                        ...timeSlots.map((time) =>
                            pw.Container(
                              width: 50,
                              child: pw.Center(
                                child: pw.Text(
                                  time,
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    font: _isArabic(time) ? arabicFont : null,
                                    color: PdfColors.black,
                                  ),
                                  textDirection: _isArabic(time) ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                                ),
                              ),
                            ),
                        ),

                      ],
                    ),
                    ...days.map((day) {
                      return pw.TableRow(
                        children: [
                          pw.Container(
                            width: 65,
                            child: pw.Center(
                              child: pw.Text(
                                day,
                                style: pw.TextStyle(
                                  fontSize: 7,
                                  font: _isArabic(day) ? arabicFont : null,
                                  color: PdfColors.black,
                                ),
                                textDirection: _isArabic(day) ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                              ),
                            ),
                          ),

                          ...timeSlots.map((time) {
                            // Find lessons for this cell
                            List<Lesson> cellLessons = lessons.where((lesson) =>
                            lesson.day == day && _isTimeWithinLesson(time, lesson)).toList();

                            // Build the cell content
                            return pw.Container(
                              height: 30,
                              color: PdfColors.white,
                              child: pw.Stack(
                                children: cellLessons.map((lesson) {
                                  return pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    color: colorToPdfColor(lesson.color),
                                    margin: pw.EdgeInsets.symmetric(vertical: 0.5),
                                    child: pw.Center(
                                      child: pw.Text(
                                        lesson.name,
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          color: PdfColors.black,
                                          
                                          font: _isArabic(lesson.name) ? arabicFont : null,
                                        ),
                                        textDirection: _isArabic(lesson.name)
                                            ? pw.TextDirection.rtl
                                            : pw.TextDirection.ltr,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          )

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


bool _isTimeWithinLesson(String time, Lesson lesson) {
  TimeOfDay cellTime = TimeOfDay(
    hour: int.parse(time.split(' - ')[0].split(':')[0]),
    minute: int.parse(time.split(' - ')[0].split(':')[1]),
  );

  return (cellTime.hour > lesson.startTime.hour ||
      (cellTime.hour == lesson.startTime.hour && cellTime.minute >= lesson.startTime.minute)) &&
      (cellTime.hour < lesson.endTime.hour ||
          (cellTime.hour == lesson.endTime.hour && cellTime.minute <= lesson.endTime.minute));
}

PdfColor colorToPdfColor(Color color) {
  return PdfColor(
      color.red / 255.0,
      color.green / 255.0,
      color.blue / 255.0,
      color.opacity
  );
}
