import 'dart:convert'; // For base64 decoding
import 'dart:io';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:madrasti/language_utils/language_constants.dart';
import 'package:madrasti/models/prof.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/school.dart';
import '../services/schoolService.dart';

Future<void> generateProfCardPdf(Prof prof, BuildContext cont) async {
  final pdf = pw.Document();

  SchoolService schoolService = SchoolService();
  School? school = schoolService.get(0);
  bool isArabic = ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')));
  // Load the Arabic font
  final ByteData arabicFontData = await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
  final arabicFont = pw.Font.ttf(arabicFontData);

  // Add a page with the card layout
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(15),
          child: pw.Container(
            height: 200,
            width: 350,
            // Add a border around the content
            padding: const pw.EdgeInsets.all(10),
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
                                style: const pw.TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ): pw.SizedBox(
                            width: 60,
                            height: 60,
                          ),
                          pw.SizedBox(height: 5),
                          (prof.image != null) ? pw.Container(
                            width: 60,
                            height: 60,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey300, width: 1),
                            ),
                            child: prof.image != null
                                ? pw.Image(
                              pw.MemoryImage(
                                base64Decode(prof.image!),
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
                              data: prof.registrationNumber ?? '',
                              drawText: false,
                            ),
                          ),
                        ]
                    ),

                    pw.SizedBox(width: 10),
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
                                  '${prof.registrationNumber}',
                                  style: ('${prof.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
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
                                    fontSize: 12,
                                    
                                  ),
                                  textDirection: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${prof.registrationNumber}',
                                  style: ('${prof.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${prof.firstName}',
                                  style: ('${prof.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
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
                                    fontSize: 12,
                                    
                                  ),
                                  textDirection: ('${translation(cont).first_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${prof.firstName}',
                                  style: ('${prof.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${prof.lastName}',
                                  style: ('${prof.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
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
                                    fontSize: 12,
                                    
                                  ),
                                  textDirection: ('${translation(cont).last_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${prof.lastName}',
                                  style: ('${prof.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${DateFormat('yyyy-MM-dd').format(prof.birthDate!)}',
                                  style: ('${prof.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
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
                                  '${DateFormat('yyyy-MM-dd').format(prof.birthDate!)}',
                                  style: ('${prof.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${prof.major}',
                                  style: ('${prof.major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${translation(cont).major}',
                                  style: ('${translation(cont).major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : pw.TextStyle(
                                    fontSize: 12,
                                    
                                  ),
                                  textDirection: ('${translation(cont).major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).major}',
                                  style: ('${translation(cont).major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : pw.TextStyle(
                                    fontSize: 12,
                                    
                                  ),
                                  textDirection: ('${translation(cont).major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width:5),
                                pw.Text(
                                  '${prof.major}',
                                  style: ('${prof.major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          pw.SizedBox(width: 5),

                        ]
                    ),
                  ],
                ):pw.Row(
                  crossAxisAlignment:pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))?pw.CrossAxisAlignment.end:pw.CrossAxisAlignment.start,
                        children: [
                          (school != null)?
                          pw.Column(
                              children: [
                                pw.Text(school.name ??'' ,
                                  style: pw.TextStyle(
                                    font: school.name != null &&
                                        school.name!.contains(RegExp(r'[\u0600-\u06FF]'))
                                        ? arabicFont
                                        : null,
                                    fontSize: 15,

                                  ),
                                  textDirection: school.name!.contains(RegExp(r'[\u0600-\u06FF]')) ? pw.TextDirection.rtl : pw
                                      .TextDirection.ltr,
                                ),
                                pw.SizedBox(height: 5),
                              ]
                          ) :pw.SizedBox(),
                          isArabic?
                          pw.Row(
                              children:[
                                pw.Text(
                                  '${prof.registrationNumber}',
                                  style: ('${prof.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
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
                                    fontSize: 12,
                                    
                                  ),
                                  textDirection: ('${translation(cont).reg_number}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${prof.registrationNumber}',
                                  style: ('${prof.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.registrationNumber}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${prof.firstName}',
                                  style: ('${prof.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
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
                                    fontSize: 12,
                                    
                                  ),
                                  textDirection: ('${translation(cont).first_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${prof.firstName}',
                                  style: ('${prof.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.firstName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${prof.lastName}',
                                  style: ('${prof.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
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
                                    fontSize: 12,
                                    
                                  ),
                                  textDirection: ('${translation(cont).last_name}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${prof.lastName}',
                                  style: ('${prof.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.lastName}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${DateFormat('yyyy-MM-dd').format(prof.birthDate!)}',
                                  style: ('${prof.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
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
                                  '${DateFormat('yyyy-MM-dd').format(prof.birthDate!)}',
                                  style: ('${prof.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.birthDate}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                              ]
                          ),
                          (isArabic)?pw.Row(
                              children:[
                                pw.Text(
                                  '${prof.major}',
                                  style: ('${prof.major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                                pw.Text(' :'),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${translation(cont).major}',
                                  style: ('${translation(cont).major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : pw.TextStyle(
                                    fontSize: 12,
                                    
                                  ),
                                  textDirection: ('${translation(cont).major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),

                              ]
                          ):pw.Row(
                              children:[
                                pw.Text(
                                  '${translation(cont).major}',
                                  style: ('${translation(cont).major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : pw.TextStyle(
                                    fontSize: 12,
                                    
                                  ),
                                  textDirection: ('${translation(cont).major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextDirection.rtl
                                      : pw.TextDirection.ltr,
                                ),
                                pw.Text(' :'),
                                pw.SizedBox(width:5),
                                pw.Text(
                                  '${prof.major}',
                                  style: ('${prof.major}'.contains(RegExp(r'[\u0600-\u06FF]')))
                                      ? pw.TextStyle(
                                    font: arabicFont,
                                    fontSize: 12,
                                    
                                  )
                                      : const pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                  textDirection: ('${prof.major}'.contains(RegExp(r'[\u0600-\u06FF]')))
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
                                style: const pw.TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ): pw.SizedBox(
                            width: 60,
                            height: 60,
                          ),
                          pw.SizedBox(height: 5),
                          (prof.image != null) ? pw.Container(
                            width: 60,
                            height: 60,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey300, width: 1),
                            ),
                            child: prof.image != null
                                ? pw.Image(
                              pw.MemoryImage(
                                base64Decode(prof.image!),
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
                              data: prof.registrationNumber ?? '',
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








