import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:intl/intl.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/models/ammount.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/group.dart';
import '../../models/school.dart';
import '../services/grouService.dart';
import '../services/schoolService.dart';




Future<void> generateIncomesPdf(
    List<Ammount>? ammounts,
    BuildContext cont,
    String date,// Pass headers as a parameter
    ) async {
  final pdf = pw.Document();
  const int rowsPerPage = 15; // Define how many rows per page

  List<String> dynamicHeaders = [
    translation(cont).name,
    translation(cont).ammount, // could be in Arabic or English
    translation(cont).date,
    translation(cont).group,
  ];
  SchoolService schoolService = SchoolService();
  School? school = schoolService.get(0);
  GroupService groupService = GroupService();

  // Load the Arabic font
  final ByteData arabicFontData = await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
  final arabicFont = pw.Font.ttf(arabicFontData);

  // Get the translated title

  final String title = '${translation(cont).incomes} :   ${translation(cont).total }   ${ammounts?.length ?? 0 }';


  // Check if title contains Arabic characters
  bool isTitleArabic = title.contains(RegExp(r'[\u0600-\u06FF]'));

  // Split the list into chunks
  if(ammounts != null) {
    for (int i = 0; i < ammounts.length; i += rowsPerPage) {
      final chunk = ammounts.sublist(i,
          i + rowsPerPage > ammounts.length ? ammounts.length : i +
              rowsPerPage);

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
                            height: 30,
                            width: 50,
                            alignment: pw.Alignment.center,
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

                      ...chunk.map((ammount) {
                        String groupName = ' _ ';
                        if(ammount.groupId != null) {
                          Groupe? group = groupService.get(ammount.groupId!);
                          if (group != null) {
                            groupName = group.name ?? '';
                          }
                        }
                        return pw.TableRow(
                          children: [
                            ammount.name ?? '',
                            ammount.ammount.toString() ?? '',
                            DateFormat('yyyy-MM-dd').format(ammount.date!) ?? '',
                            groupName

                          ].map((cell) {
                            bool isArabic = cell.contains(
                                RegExp(r'[\u0600-\u06FF]'));
                            bool isArabic2 = translation(cont).payment_student.contains(
                                RegExp(r'[\u0600-\u06FF]'));
                            return pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child: (ammount.personId == null || cell != ammount.name)? pw.Text(
                                cell,
                                style: pw.TextStyle(
                                    font: isArabic ? arabicFont : null,
                                    fontSize: 8
                                ),
                                textDirection: isArabic
                                    ? pw.TextDirection.rtl
                                    : pw.TextDirection.ltr,
                              ):
                              (!isArabic2)?pw.Row(
                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      '${translation(cont).payment_student} : ',
                                      style: pw.TextStyle(
                                          font: isArabic2 ? arabicFont : null,
                                          fontSize: 8
                                      ),
                                      textDirection: isArabic2
                                          ? pw.TextDirection.rtl
                                          : pw.TextDirection.ltr,
                                    ),
                                    pw.Text(
                                      cell,
                                      style: pw.TextStyle(
                                          font: isArabic ? arabicFont : null,
                                          fontSize: 8
                                      ),
                                      textDirection: isArabic
                                          ? pw.TextDirection.rtl
                                          : pw.TextDirection.ltr,
                                    ),
                                  ]
                              ) : pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      cell,
                                      style: pw.TextStyle(
                                          font: isArabic ? arabicFont : null,
                                          fontSize: 8
                                      ),
                                      textDirection: isArabic
                                          ? pw.TextDirection.rtl
                                          : pw.TextDirection.ltr,
                                    ),
                                    pw.Text(
                                      '${translation(cont).payment_student} : ',
                                      style: pw.TextStyle(
                                          font: isArabic2 ? arabicFont : null,
                                          fontSize: 8
                                      ),
                                      textDirection: isArabic2
                                          ? pw.TextDirection.rtl
                                          : pw.TextDirection.ltr,
                                    ),
                                  ]
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
  if(ammounts != null && ammounts.isNotEmpty) {
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




