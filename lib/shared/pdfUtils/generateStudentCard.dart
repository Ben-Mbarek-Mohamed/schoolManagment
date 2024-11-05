import 'dart:convert'; // For base64 decoding
import 'dart:io';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madrasti/shared/services/schoolService.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/school.dart';
import '../../models/student.dart';

Future<void> generateStudentCardPdf(Student student, BuildContext cont) async {
  final pdf = pw.Document();

  SchoolService schoolService = SchoolService();
  School? school = schoolService.get(0);

  bool isArabic = ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')));
  // Load the Arabic font
  final ByteData arabicFontData = await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
  final arabicFont = pw.Font.ttf(arabicFontData);

  final ByteData defaultFontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
  final defaultFont = pw.Font.ttf(defaultFontData);

  // Add a page with the card layout
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(1),
          child: pw.Container(
            height: 200,
            width: 350,
            // Add a border around the content
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blue, width: 1), // Border around content
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                isArabic?
                pw.Row(
                  crossAxisAlignment:pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                                style:  pw.TextStyle(
                                  font: defaultFont,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ): pw.SizedBox(
                            width: 60,
                            height: 60,
                          ),
                          pw.SizedBox(height: 5),
                          (student.image != null) ? pw.Container(
                            width: 60,
                            height: 60,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey300, width: 1),
                            ),
                            child: student.image != null
                                ? pw.Image(
                              pw.MemoryImage(
                                base64Decode(student.image!),
                              ),
                              fit: pw.BoxFit.cover,
                            )
                                : pw.Center(
                              child: pw.Text(
                                '',
                                style:  pw.TextStyle(
                                  font: defaultFont,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ): pw.Container(
                            width: 60,
                            height: 60,
                            child:
                            pw.Placeholder(color: PdfColors.blue),),
                          pw.SizedBox(height: 10),
                          pw.Container(
                            width: 150,
                            height: 40,
                            child: pw.BarcodeWidget(
                              barcode: pw.Barcode.code128(),
                              data: student.registrationNumber ?? '',
                              drawText: false,
                            ),
                          ),
                        ]
                    ),

                    pw.Spacer(),
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))?pw.CrossAxisAlignment.end:pw.CrossAxisAlignment.start,
                        children: [
                          (school != null)?
                          pw.Column(
                              children: [
                                pw.Text(school.name ??'',
                                  style: pw.TextStyle(
                                    font: school.name != null &&
                                        school.name!.contains(RegExp(r'[\u0600-\u06FF]'))
                                        ? arabicFont
                                        : null,
                                    fontSize: 15,

                                  ),
                                  textDirection: isArabic ? pw.TextDirection.rtl : pw
                                      .TextDirection.ltr,
                                ),
                              ]
                          ) :pw.SizedBox(),
                          isArabic?
                          pw.Row(
                              children:[
                                pw.Text(
                                  '${student.registrationNumber}',
                                  style: ('${student.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                                pw.Text(' :'),
                                pw.SizedBox(width: 10),
                                pw.Text(
                                  '${translation(cont).reg_number}',
                                  style: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ):
                          pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).reg_number}',
                                  style: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${student.registrationNumber}',
                                  style: ('${student.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${student.firstName}',
                                  style: ('${student.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),

                                pw.Text(
                                  '${translation(cont).first_name}',
                                  style: ('${translation(cont).first_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).first_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).first_name}',
                                  style: ('${translation(cont).first_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).first_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${student.firstName}',
                                  style: ('${student.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${student.lastName}',
                                  style: ('${student.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),

                                pw.Text(
                                  '${translation(cont).last_name}',
                                  style: ('${translation(cont).last_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).last_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).last_name}',
                                  style: ('${translation(cont).last_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).last_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${student.lastName}',
                                  style: ('${student.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${DateFormat('yyyy-MM-dd').format(student.birthDate!)}',
                                  style: ('${student.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    //font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    //font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${translation(cont).birth_date}',
                                  style: ('${translation(cont).birth_date}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).birth_date}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).birth_date}',
                                  style: ('${translation(cont).birth_date}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).birth_date}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${DateFormat('yyyy-MM-dd').format(student.birthDate!)}',
                                  style: ('${student.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${student.level}',
                                  style: ('${student.level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${translation(cont).level}',
                                  style: ('${translation(cont).level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).level}',
                                  style: ('${translation(cont).level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width:5),
                                pw.Text(
                                  '${student.level}',
                                  style: ('${student.level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),

                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${student.phone ?? ''}',
                                  style: ('${student.phone ?? ''}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.phone ?? ''}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${translation(cont).phone_num}',
                                  style: ('${translation(cont).phone_num}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).phone_num}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).phone_num}',
                                  style: ('${translation(cont).phone_num}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).phone_num}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width:5),
                                pw.Text(
                                  '${student.phone ?? ''}',
                                  style: ('${student.phone ?? ''}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.phone ?? ''}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),

                        ]
                    ),
                  ],
                ):
                pw.Row(
                  crossAxisAlignment:pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))?pw.CrossAxisAlignment.end:pw.CrossAxisAlignment.start,
                        children: [
                          (school != null)?
                          pw.Column(
                              children: [
                                pw.Text(school.name ??'',
                                  style: pw.TextStyle(
                                    font: school.name != null &&
                                        school.name!.contains(RegExp(r'[\u0600-\u06FF]'))
                                        ? arabicFont
                                        : null,
                                    fontSize: 15,

                                  ),
                                  textDirection: school.name!
                                      .contains(RegExp(r'[\u0600-\u06FF]'))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.SizedBox(height: 5),
                              ]
                          ) :pw.SizedBox(),
                          isArabic?
                          pw.Row(
                              children:[
                                pw.Text(
                                  '${student.registrationNumber}',
                                  style: ('${student.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                                pw.Text(' :'),
                                pw.SizedBox(width: 10),
                                pw.Text(
                                  '${translation(cont).reg_number}',
                                  style: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ):
                          pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).reg_number}',
                                  style: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${student.registrationNumber}',
                                  style: ('${student.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${student.firstName}',
                                  style: ('${student.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),

                                pw.Text(
                                  '${translation(cont).first_name}',
                                  style: ('${translation(cont).first_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).first_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).first_name}',
                                  style: ('${translation(cont).first_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).first_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${student.firstName}',
                                  style: ('${student.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${student.lastName}',
                                  style: ('${student.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),

                                pw.Text(
                                  '${translation(cont).last_name}',
                                  style: ('${translation(cont).last_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).last_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).last_name}',
                                  style: ('${translation(cont).last_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).last_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${student.lastName}',
                                  style: ('${student.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${DateFormat('yyyy-MM-dd').format(student.birthDate!)}',
                                  style: ('${student.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${translation(cont).birth_date}',
                                  style: ('${translation(cont).birth_date}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).birth_date}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).birth_date}',
                                  style: ('${translation(cont).birth_date}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).birth_date}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${DateFormat('yyyy-MM-dd').format(student.birthDate!)}',
                                  style: ('${student.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${student.level}',
                                  style: ('${student.level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${translation(cont).level}',
                                  style: ('${translation(cont).level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).level}',
                                  style: ('${translation(cont).level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width:5),
                                pw.Text(
                                  '${student.level}',
                                  style: ('${student.level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.level}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${student.phone ?? ''}',
                                  style: ('${student.phone ?? ''}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.phone ?? ''}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${translation(cont).phone_num}',
                                  style: ('${translation(cont).phone_num}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).phone_num}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).phone_num}',
                                  style: ('${translation(cont).phone_num}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      : pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,

                                  ),
                                  textDirection: ('${translation(cont).phone_num}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width:5),
                                pw.Text(
                                  '${student.phone ?? ''}',
                                  style: ('${student.phone ?? ''}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,

                                  )
                                      :  pw.TextStyle(
                                    font: defaultFont,
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${student.phone ?? ''}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          pw.SizedBox(width: 5),
                        ]
                    ),
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
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
                                style:  pw.TextStyle(
                                  font: defaultFont,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ): pw.SizedBox(
                            width: 60,
                            height: 60,
                          ),
                          pw.SizedBox(height: 5),
                          (student.image != null) ? pw.Container(
                            width: 60,
                            height: 60,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey300, width: 1),
                            ),
                            child: student.image != null
                                ? pw.Image(
                              pw.MemoryImage(
                                base64Decode(student.image!),
                              ),
                              fit: pw.BoxFit.cover,
                            )
                                : pw.Center(
                              child: pw.Text(
                                '',
                                style:  pw.TextStyle(
                                  font: defaultFont,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ): pw.Container(
                            width: 60,
                            height: 60,
                            child:
                            pw.Placeholder(color: PdfColors.blue),),
                          pw.SizedBox(height: 10),
                          pw.Container(
                            width: 150,
                            height: 40,
                            child: pw.BarcodeWidget(
                              barcode: pw.Barcode.code128(),
                              data: student.registrationNumber ?? '',
                              drawText: false,
                            ),
                          ),
                        ]
                    ),

                  ],
                ),
                // Add space below the image/info and the border
              ],
            ),
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








