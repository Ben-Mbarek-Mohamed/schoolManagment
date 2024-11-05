import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/models/attendance.dart';
import 'package:madrasti/models/group.dart';
import 'package:madrasti/shared/services/profService.dart';
import 'package:madrasti/shared/services/studentService.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/models/prof.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/school.dart';
import '../../models/student.dart';
import '../services/schoolService.dart';



Future<void> generatePresencesPdf(
    Attendance attendance,
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
    translation(cont).category

  ];

  StudentService studentService = new StudentService();
  ProfService profService = new ProfService();

  List<Student> students = studentService.getAll().where((element) => attendance.presentStudent!.contains(element.id)).toList();
  List<Prof> profsList = profService.getAll().where((element) => attendance.presentProf!.contains(element.id)).toList();

  List<Person> persons = [];
  for(Student std in students){
    Person pr = Person(
      regNumber: std.registrationNumber!,
      firstName: std.firstName!,
      lastName: std.lastName!,
    );
    persons.add(pr);
  }
  for(Prof prf in profsList){
    Person pr = Person(
      regNumber: prf.registrationNumber!,
      firstName: prf.firstName!,
      lastName: prf.lastName!,
    );
    persons.add(pr);
  }

  SchoolService schoolService = SchoolService();
  School? school = schoolService.get(0);


  // Load the Arabic font
  final ByteData arabicFontData = await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
  final arabicFont = pw.Font.ttf(arabicFontData);

  // Get the translated title
  final String title = '${translation(cont).present} :   ${translation(cont).total }   ${students.length + profsList.length }';

  // Check if title contains Arabic characters
  bool isTitleArabic = title.contains(RegExp(r'[\u0600-\u06FF]'));

  // Split the list into chunks
  if(persons != null) {
    for (int i = 0; i < persons.length; i += rowsPerPage) {
      final chunk = persons.sublist(
          i, i + rowsPerPage > persons.length ? persons.length : i + rowsPerPage);

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
                      ...chunk.map((person) {
                        return pw.TableRow(
                          children: [
                            person.regNumber ?? '',
                            person.firstName ?? '',
                            person.lastName ?? '',
                            (person.regNumber.length == 12)? translation(cont).teacher : translation(cont).student

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
  if(persons != null && persons.isNotEmpty) {
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


class Person{
  late String regNumber;
  late String firstName;
  late String lastName;

  Person({required this.regNumber,required this.firstName,required this.lastName});
}







