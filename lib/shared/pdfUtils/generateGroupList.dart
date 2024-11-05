import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/models/group.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/school.dart';
import '../services/schoolService.dart';



Future<void> generateGroupsPdf(
    List<Groupe>? groups,
    BuildContext cont,
    String date,// Pass headers as a parameter
    ) async {
  final pdf = pw.Document();
  const int rowsPerPage = 15; // Define how many rows per page
  SchoolService schoolService = SchoolService();
  School? school = schoolService.get(0);
  List<String> dynamicHeaders = [
    translation(cont).name,
    translation(cont).system, // could be in Arabic or English
    translation(cont).price_per_student,
    translation(cont).price_per_teacher,
    translation(cont).prof_percentage,
    translation(cont).students_number,
    translation(cont).teachers_number,
    translation(cont).class_days,
  ];

  // Load the Arabic font
  final ByteData arabicFontData = await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
  final arabicFont = pw.Font.ttf(arabicFontData);

  // Get the translated title
  final String title = '${translation(cont).groups } :   ${translation(cont).total }   ${(groups != null) ?groups.length: 0 }';
  String getSystem(Groupe data, context){
    return (data.isRegular!)
        ? translation(context).regular
        : translation(context).session;
  }

  // Check if title contains Arabic characters
  bool isTitleArabic = title.contains(RegExp(r'[\u0600-\u06FF]'));

  // Split the list into chunks
  if(groups != null) {
    for (int i = 0; i < groups.length; i += rowsPerPage) {
      final chunk = groups.sublist(i,
          i + rowsPerPage > groups.length ? groups.length : i +
              rowsPerPage);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(0),
              child: pw.Column(
                crossAxisAlignment: isTitleArabic?pw.CrossAxisAlignment.end:pw.CrossAxisAlignment.start,
                children: [
                  (school != null)?pw.Text(
                    school.name ?? '', // Use the translated title
                    style: pw.TextStyle(
                      font: school.name != null && school.name!.contains(RegExp(r'[\u0600-\u06FF]')) ? arabicFont : null,
                      fontSize: 15,
                      
                    ),
                    textDirection: school.name!
                        .contains(RegExp(r'[\u0600-\u06FF]'))
                        ? pw.TextDirection.rtl
                        : pw.TextDirection.ltr,
                  ):pw.SizedBox(),
                  isTitleArabic?pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        (school != null && school.image != null) ? pw.Container(
                          width: 60,
                          height: 60,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.grey300, width: 1),
                          ),
                          child: school.image != null
                              ? pw.Image(
                            pw.MemoryImage(
                              base64Decode(school.image!),
                            ),
                            fit: pw.BoxFit.cover,
                          )
                              : pw.Center(
                            child: pw.Text(
                              '',
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ): pw.SizedBox(
                          width: 60,
                          height: 60,
                        ),
                        pw.Column(
                            crossAxisAlignment: isTitleArabic?pw.CrossAxisAlignment.end:pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                '', // Use the translated title
                                style: pw.TextStyle(
                                  font: isTitleArabic ? arabicFont : null,
                                  fontSize: 15,
                                  
                                ),
                                textDirection: isTitleArabic ? pw.TextDirection.rtl : pw
                                    .TextDirection.ltr,
                              ),
                              pw.Text(
                                title, // Use the translated title
                                style: pw.TextStyle(
                                  font: isTitleArabic ? arabicFont : null,
                                  fontSize: 15,
                                  
                                ),
                                textDirection: isTitleArabic ? pw.TextDirection.rtl : pw
                                    .TextDirection.ltr,
                              ),
                              pw.Text(
                                date, // Use the translated title
                                style: pw.TextStyle(
                                  font: isTitleArabic ? arabicFont : null,
                                  fontSize: 15,
                                  
                                ),
                                textDirection: isTitleArabic ? pw.TextDirection.rtl : pw
                                    .TextDirection.ltr,
                              ),

                            ]
                        ),
                      ]
                  ):pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                            crossAxisAlignment: isTitleArabic?pw.CrossAxisAlignment.end:pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                '', // Use the translated title
                                style: pw.TextStyle(
                                  font: isTitleArabic ? arabicFont : null,
                                  fontSize: 15,
                                  
                                ),
                                textDirection: isTitleArabic ? pw.TextDirection.rtl : pw
                                    .TextDirection.ltr,
                              ),
                              pw.Text(
                                title, // Use the translated title
                                style: pw.TextStyle(
                                  font: isTitleArabic ? arabicFont : null,
                                  fontSize: 15,
                                  
                                ),
                                textDirection: isTitleArabic ? pw.TextDirection.rtl : pw
                                    .TextDirection.ltr,
                              ),
                              pw.Text(
                                date, // Use the translated title
                                style: pw.TextStyle(
                                  font: isTitleArabic ? arabicFont : null,
                                  fontSize: 15,
                                  
                                ),
                                textDirection: isTitleArabic ? pw.TextDirection.rtl : pw
                                    .TextDirection.ltr,
                              ),

                            ]
                        ),
                        (school != null && school.image != null) ? pw.Container(
                          width: 60,
                          height: 60,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.grey300, width: 1),
                          ),
                          child: school.image != null
                              ? pw.Image(
                            pw.MemoryImage(
                              base64Decode(school.image!),
                            ),
                            fit: pw.BoxFit.cover,
                          )
                              : pw.Center(
                            child: pw.Text(
                              '',
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ): pw.SizedBox(
                          width: 60,
                          height: 60,
                        ),
                      ]
                  ),
                  pw.SizedBox(height: 5),
                  (groups.isNotEmpty)?
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: dynamicHeaders.map((header) {
                          bool isArabic = header.contains(
                              RegExp(r'[\u0600-\u06FF]'));
                          return pw.Container(
                            alignment: pw.Alignment.center,
                            height: 50,
                            width: 70,
                            color: PdfColors.blue,
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              header,
                              style: pw.TextStyle(
                                font: isArabic ? arabicFont : null,
                                fontSize: isArabic ? 10 : 8,
                                color: PdfColors.white,
                                
                              ),
                              textDirection: isArabic
                                  ? pw.TextDirection.rtl
                                  : pw.TextDirection.ltr,
                            ),
                          );
                        }).toList(),
                      ),
                      ...chunk.map((group) {
                        String sys = getSystem(group,cont);
                        String sessiondays = '';
                        for (String day in group.sessionDays!.map((e) => e.day!)) {
                          if (day == 'monday') {
                            sessiondays = sessiondays + translation(cont).monday + ' ,';
                          }
                          if (day == 'tuesday') {
                            sessiondays = sessiondays + translation(cont).tuesday + ' ,';
                          }
                          if (day == 'wednesday') {
                            sessiondays = sessiondays + translation(cont).wednesday + ' ,';
                          }
                          if (day == 'thursday') {
                            sessiondays = sessiondays + translation(cont).thursday + ' ,';
                          }
                          if (day == 'friday') {
                            sessiondays = sessiondays + translation(cont).friday + ' ,';
                          }
                          if (day == 'saturday') {
                            sessiondays = sessiondays + translation(cont).saturday + ' ,';
                          }
                          if (day == 'sunday') {
                            sessiondays = sessiondays + translation(cont).sunday + ' ,';
                          }
                        }
                        return pw.TableRow(
                          children: [
                            group.name ?? '',
                            sys ?? '',
                            group.studentPrice.toString() ?? '',
                            group.profPrice != null ? group.profPrice.toString() : '-',  // Check for null
                            group.profPoucentage != null && group.profPrice == null ? '${group.profPoucentage.toString().split('.')[0]} %' : '-',
                            group.studentsId!.length.toString() ?? '',
                            group.profsId!.length.toString() ?? '',
                            sessiondays ,
                          ].map((cell) {
                            bool isArabic = cell.contains(
                                RegExp(r'[\u0600-\u06FF]'));
                            return pw.Container(
                              alignment: pw.Alignment.center,
                              width: 70,
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                cell,
                                style: pw.TextStyle(
                                    font: isArabic ? arabicFont : null,
                                    fontSize: 8
                                ),
                                textDirection: isArabic
                                    ? pw.TextDirection.rtl
                                    : pw.TextDirection.ltr,
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ],
                  ):pw.SizedBox(),
                ],
              ),
            );
          },
        ),
      );
    }
  }
  if(groups != null && groups.isNotEmpty) {
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
}




