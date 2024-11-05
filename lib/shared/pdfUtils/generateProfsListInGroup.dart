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
import 'package:intl/intl.dart';
import 'package:madrasti/models/prof.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/ammount.dart';
import '../../models/school.dart';
import '../services/attendanceService.dart';
import '../services/schoolService.dart';


Future<void> generateProfsInGroupPdf(
    List<Prof>? profs,
    BuildContext cont,
    Groupe group,
    String date
    ) async {
  final pdf = pw.Document();
  const int rowsPerPage = 15; // Define how many rows per page

  List<String> dynamicHeaders = [
    translation(cont).reg_number,
    translation(cont).first_name, // could be in Arabic or English
    translation(cont).last_name,
    translation(cont).birth_date,
    translation(cont).major,
    translation(cont).amount_due,
    translation(cont).reg_date,
    translation(cont).absent
  ];

  // Load the Arabic font
  final ByteData arabicFontData = await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
  final arabicFont = pw.Font.ttf(arabicFontData);

  // Get the translated title

  final String title = '${translation(cont).profs_groups} :   ${translation(cont).total }   ${profs?.length ?? 0 }';

  SchoolService schoolService = SchoolService();
  School? school = schoolService.get(0);

  // Check if title contains Arabic characters
  bool isTitleArabic = title.contains(RegExp(r'[\u0600-\u06FF]'));

  // Split the list into chunks
  if(profs != null) {
    for (int i = 0; i < profs.length; i += rowsPerPage) {
      final chunk = profs.sublist(
          i, i + rowsPerPage > profs.length ? profs.length : i + rowsPerPage);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(1),
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
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: dynamicHeaders.map((header) {
                          bool isArabic = header.contains(
                              RegExp(r'[\u0600-\u06FF]'));
                          return pw.Container(
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
                      ...chunk.map((prof) {
                        return pw.TableRow(
                          children: [
                            prof.registrationNumber ?? '',
                            prof.firstName ?? '',
                            prof.lastName ?? '',
                            prof.birthDate != null
                                ? DateFormat('yyyy-MM-dd').format(
                                prof.registrationDate!)
                                : '',
                            prof.major ?? '',
                            getAmmount(prof, group, cont).toStringAsFixed(2) ?? '',
                            prof.registrationDate != null
                                ? DateFormat('yyyy-MM-dd').format(
                                prof.registrationDate!)
                                : '',
                            _getAbsences(prof.id!, group.id!).toString() ?? '',
                          ].map((cell) {
                            bool isArabic = cell.contains(
                                RegExp(r'[\u0600-\u06FF]'));
                            return pw.Container(
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
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
  if(profs != null && profs.isNotEmpty){
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

double getAmmount(Prof prof, Groupe groupe, context) {
  double result = 0;
  for (Ammount ammount in prof.dueAmmount!) {
    if (ammount.groupId! == groupe.id) {
      result += ammount.ammount!;
    }
  }
  if (prof.payedAmmount != null) {
    for (Ammount ammount in prof.payedAmmount!) {
      if (ammount.groupId! == groupe.id) {
        result -= ammount.ammount!;
      }
    }
  }

  return result;
}

int _getAbsences(int prfId, int grpId) {
  AttendanceService attendanceService = new AttendanceService();
  return attendanceService
      .getAll()
      .where((element) =>
  element.absentProf!.contains(prfId) && element.groupId! == grpId)
      .length;
}



