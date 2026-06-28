import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_yoklama_web/helper/aes256.dart';
import 'package:qr_yoklama_web/pages/qrCode_page.dart';
import 'package:qr_yoklama_web/widgets/elevatedButton.dart';
import 'package:qr_yoklama_web/widgets/lessonstableWidgets/tableItem.dart';
import 'package:qr_yoklama_web/widgets/textFormField.dart';

// ignore: must_be_immutable
class LessonTable extends StatefulWidget {
  String userUID;
  int dersHaftasi;
  List<QueryDocumentSnapshot>? dersler;
  GeoPoint konum;
  LessonTable({
    super.key,
    required this.userUID,
    required this.dersler,
    required this.dersHaftasi,
    required this.konum,
  });

  @override
  State<LessonTable> createState() => _LessonTableState();
}

class _LessonTableState extends State<LessonTable> {
  List<String> secilenDersler = [];
  TextEditingController numaraController = TextEditingController();
  DocumentSnapshot? ogrenci;

  //late String bolumId, fakulteId;

  List<List<Map<String, dynamic>>> tablo = [
    // 1. SATIR: BAŞLIKLAR
    [
      {
        'icon': null,
        'bgColor': Colors.transparent,
        'sbtitleColor': Colors.transparent,
        'titleColor': Colors.transparent,
        'borderColor': Colors.transparent,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.transparent,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': 'monday'.tr(),
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.transparent,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': 'tuesday'.tr(),
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.transparent,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': 'wednesday'.tr(),
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.transparent,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': 'thursday'.tr(),
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.transparent,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': 'friday'.tr(),
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.transparent,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': 'saturday'.tr(),
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.transparent,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': 'sunday'.tr(),
        'subtitle': '',
        'onTap': () {},
      },
    ],

    // 2. SATIR: 09:00 - 09:45
    [
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': '09:00',
        'subtitle': '09:45',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
    ],

    // 3. SATIR: 10:00 - 10:45
    [
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': '10:00',
        'subtitle': '10:45',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
    ],

    // 4. SATIR: 11:00 - 11:45
    [
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': '11:00',
        'subtitle': '11:45',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
    ],

    // 5. SATIR: 13:00 - 13:45
    [
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': '13:00',
        'subtitle': '13:45',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
    ],

    // 6. SATIR: 14:00 - 14:45
    [
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': '14:00',
        'subtitle': '14:45',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
    ],

    // 7. SATIR: 15:00 - 15:45
    [
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': '15:00',
        'subtitle': '15:45',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
    ],

    // 8. SATIR: 16:00 - 16:45
    [
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': '16:00',
        'subtitle': '16:45',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
    ],

    // 9. SATIR: 17:00 - 17:45
    [
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': '17:00',
        'subtitle': '17:45',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
    ],

    // 10. SATIR: 18:00 - 18:45
    [
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': '18:00',
        'subtitle': '18:45',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
    ],

    // 11. SATIR: 19:00 - 19:45
    [
      {
        'icon': null,
        'bgColor': Colors.black45,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.transparent,
        'title': '19:00',
        'subtitle': '19:45',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': null,
        'bgColor': Colors.black12,
        'sbtitleColor': Colors.white,
        'titleColor': Colors.white,
        'borderColor': Colors.white54,
        'title': '',
        'subtitle': '',
        'onTap': () {},
      },
    ],
  ];

  @override
  void initState() {
    decodeDersler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 500,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: BoxBorder.all(color: Colors.white24),
            color: Colors.white,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 5, 50, 87),
                Color.fromARGB(255, 49, 132, 227),
                //  Color(0xFF4A90E2),
                // Color(0xFF5AA9F4),
                // Color(0xFF7BC6FF),
                //  Color(0xFFEAF6FF),
              ],
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.all(15),

                child: Column(
                  children: tablo.map((List<Map<String, dynamic>> satir) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: satir.map((Map<String, dynamic> hucre) {
                        return Tableitem(
                          icon: hucre['icon'],
                          bgColor: hucre['bgColor'],
                          sbtitleColor: hucre['sbtitleColor'],
                          titleColor: hucre['titleColor'],
                          borderColor: hucre['borderColor'],
                          title: hucre['title'] ?? '',
                          subtitle: hucre['subtitle'] ?? '',
                          onTap: hucre['onTap'] ?? () {},
                          liste: secilenDersler,
                          satir: (tablo.indexOf(satir)),
                          sutun: (satir.indexOf(hucre)),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 60,
          width: 500,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: BoxBorder.all(color: Colors.white12),
          ),

          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      secilenDersler.clear();
                    });
                  },
                  child: Text(
                    'clear_selection'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(height: 40, color: Colors.grey, width: 1),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    secilenDersler.isNotEmpty
                        ? showModal(context)
                        : _uyariVer('warning_select_lessons'.tr());
                  },

                  child: Text(
                    'add_student'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(height: 40, color: Colors.grey, width: 1),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    if (secilenDersler.isEmpty) {
                      _uyariVer('warning_no_lesson_in_cell'.tr());
                      return;
                    }

                    try {
                      List<int> gunler = [];
                      List<int> saatler = [];
                      List<String> dersKodlari = [];

                      for (var element in secilenDersler) {
                        List<String> parts = element.split("-");

                        int saat = int.parse(parts[0]);
                        int gun = int.parse(parts[1]);

                        if (saat < tablo.length && gun < tablo[saat].length) {
                          var hucre = tablo[saat][gun];
                          String? kod = hucre['dersKod'];

                          if (kod == null || kod.isEmpty) {
                            _uyariVer(
                              'warning_no_lesson_in_cell_detail'.tr(
                                namedArgs: {
                                  'saat': saat.toString(),
                                  'gun': gun.toString(),
                                },
                              ),
                            );
                            return;
                          }

                          saatler.add(saat);
                          gunler.add(gun);
                          dersKodlari.add(kod);
                        }
                      }

                      // KURAL 1: Aynı Ders Kontrolü (Ders kodları aynı mı?)
                      if (!dersKodlari.every((k) => k == dersKodlari[0])) {
                        _uyariVer('warning_same_lesson'.tr());
                        return;
                      }

                      // KURAL 2: Aynı Gün Kontrolü
                      if (!gunler.every((g) => g == gunler[0])) {
                        _uyariVer('warning_same_day'.tr());
                        return;
                      }

                      // KURAL 3: Ardışık Saat Kontrolü
                      saatler.sort();
                      for (int i = 0; i < saatler.length - 1; i++) {
                        if (saatler[i + 1] - saatler[i] != 1) {
                          _uyariVer('warning_consecutive'.tr());
                          return;
                        }
                      }

                      // KURAL 4: Maksimum 3 Saat
                      if (secilenDersler.length > 3) {
                        _uyariVer('warning_max_hours'.tr());
                        return;
                      }

                      // KURAL 5: GÜN VE SAAT KONTROLÜ
                      DateTime simdi = DateTime.now();
                      int suankiGun =
                          simdi.weekday; // 1: Pazartesi ... 7: Pazar

                      // 1. KONTROL: Seçilen gün ile bugünün eşleşmesi
                      if (gunler[0] != suankiGun) {
                        _uyariVer(
                          'Yoklamayı sadece dersin olduğu gün başlatabilirsiniz.',
                        );
                        // Not: Easy localization için dil dosyanıza ekleyip 'warning_wrong_day'.tr() şeklinde kullanabilirsiniz.
                        return;
                      }

                      // 2. KONTROL: Seçilen saat aralığında mıyız?
                      // tablo[saat][0] -> ilgili satırın saat dilimini verir.
                      // saatler listesi sıralı olduğu için ilk eleman dersin başlangıç, son eleman bitiş süresidir.
                      String baslangicSaati =
                          tablo[saatler.first][0]['title']; // Örn: "09:00"
                      String bitisSaati =
                          tablo[saatler
                              .last][0]['subtitle']; // Örn: "09:45" (veya blok derste "11:45")

                      List<String> basParts = baslangicSaati.split(':');
                      List<String> bitParts = bitisSaati.split(':');

                      DateTime dersBaslamaZamani = DateTime(
                        simdi.year,
                        simdi.month,
                        simdi.day,
                        int.parse(basParts[0]),
                        int.parse(basParts[1]),
                      );

                      DateTime dersBitisZamani = DateTime(
                        simdi.year,
                        simdi.month,
                        simdi.day,
                        int.parse(bitParts[0]),
                        int.parse(bitParts[1]),
                      );

                      // Opsiyonel Esneklik: Öğretmen dersten 10 dakika önce yoklamayı başlatabilsin (İsterseniz bu satırı silebilirsiniz).
                      DateTime izinVerilenBaslangic = dersBaslamaZamani
                          .subtract(const Duration(minutes: 10));

                      if (simdi.isBefore(izinVerilenBaslangic) ||
                          simdi.isAfter(dersBitisZamani)) {
                        _uyariVer(
                          'Yoklamayı yalnızca $baslangicSaati - $bitisSaati saatleri arasında başlatabilirsiniz.',
                        );
                        // Not: Easy localization için 'warning_wrong_time'.tr() kullanabilirsiniz.
                        return;
                      }
                      // ------------------------------------------------

                      String dsifre =
                          "${dersKodlari[0]}|"
                          "${secilenDersler.join(',')}|"
                          "h${widget.dersHaftasi.toString()}|"
                          "${widget.konum.latitude}|"
                          "${widget.konum.longitude}"; // Hafta

                      print("Ham Veri: $dsifre");

                      String sifreliMetin = AESHelper.encryptText(dsifre);

                      print("Şifreli Veri (QR): $sifreliMetin");

                      String kisaQr = sifreliMetin.substring(0, 8);

                      print("Kısa Şifreli Veri (QR ilk 8): $kisaQr");

                      String cozulmusSifre = AESHelper.decryptText(
                        sifreliMetin,
                      ); //silinecek

                      print("Çözülmüş Şİfreli veri : $cozulmusSifre");

                      // Seçilen dersin verisine ulaşalım (dersKodlari[0] seçilen dersin document ID'sidir)
                      var secilenDersDoc = widget.dersler!.firstWhere(
                        (doc) => doc.id == dersKodlari[0],
                      );
                      var dersData =
                          secilenDersDoc.data() as Map<String, dynamic>;

                      // Verileri güvenli bir şekilde alalım
                      String fId = dersData['fakulte_id'] ?? '';
                      String bId = dersData['bolum_id'] ?? '';

                      yeniYoklamaOturumuBaslat(
                        haftaNo: widget.dersHaftasi,
                        qr: sifreliMetin,
                        kisaQr: kisaQr,
                        bolumId: bId,
                        fakulteId: fId,
                        dersKodu: dersKodlari[0],
                        dersHucreleri: secilenDersler,
                        sifresizQr: dsifre,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrcodePage(
                            sifre: sifreliMetin,
                            kisaSifre: kisaQr,
                          ),
                        ),
                      );
                    } catch (e) {
                      print("İşlem Hatası: $e");
                      _uyariVer('warning_error'.tr());
                    }
                  },
                  child: Text(
                    'take_attendance'.tr(),
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void decodeDersler() {
    if (widget.dersler == null) return;

    for (var doc in widget.dersler!) {
      final dynamic data = doc.data();
      if (data != null && data is Map) {
        final List? indexler = data['ders_takvimi'] as List?;

        if (indexler != null) {
          indexler.forEach((element) {
            try {
              if (element is Map) {
                int gun = int.parse(element['gun'].toString());
                int saat = int.parse(element['saat'].toString());
                if (gun < tablo.length && saat < tablo[gun].length) {
                  tablo[saat][gun]['title'] = data['ders_ad'] ?? '';
                  tablo[saat][gun]['subtitle'] = data['ders_sinif'] ?? '';
                  tablo[saat][gun]['dersKod'] = doc.id;
                }
              }
            } catch (e) {
              print("Hücre ayrıştırma hatası: $e");
            }
          });
        }
      }
    }
    setState(() {});
  }

  void dersListesineEkle(String dersKodu) {
    secilenDersler.add(dersKodu);
  }

  void _uyariVer(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mesaj),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void onayVer(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(mesaj)),
        backgroundColor: const Color.fromARGB(255, 97, 218, 107),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> yeniYoklamaOturumuBaslat({
    required int haftaNo,
    required String sifresizQr,
    required String qr,
    required String kisaQr,
    required String bolumId,
    required String fakulteId,
    required String dersKodu,
    required List<String> dersHucreleri,
  }) async {
    // Boş ID kontrolü
    if (fakulteId.isEmpty || bolumId.isEmpty) {
      print("❌ Hata: Fakülte veya Bölüm ID boş!");
      return;
    }

    String docName = "hafta_$haftaNo";

    final docRef = FirebaseFirestore.instance
        .collection('Fakulteler')
        .doc(fakulteId)
        .collection('Bolumler')
        .doc(bolumId)
        .collection('Dersler')
        .doc(dersKodu)
        .collection('Acilan_Yoklama_Oturumlari')
        .doc(docName);

    Map<String, dynamic> eklenecekVeriler = {
      'QR': qr,
      'kisaQr': kisaQr,
      'aktif_mi': true, // Yazım hatası düzeltildi
      'baslangic_saati': FieldValue.serverTimestamp(),
      'son_gecerlilik_saati': Timestamp.fromDate(
        DateTime.now().add(const Duration(minutes: 2)),
      ), // Firebase uyumlu Timestamp
      'hafta': haftaNo,
      'konum': const GeoPoint(0.0, 0.0),
      'maks_mesafe': 40,
      'sifresizQr': sifresizQr,
    };

    // Katılanlar listelerini başlat
    for (var hucre in dersHucreleri) {
      // Firebase field isimlerinde "-" karakteri bazen sorun çıkarabilir,
      // gerekirse hucre.replaceAll("-", "_") yapabilirsiniz.
      eklenecekVeriler['${hucre}_KatilanlarId'] = [];
    }

    try {
      await docRef.set(eklenecekVeriler, SetOptions(merge: true));
      print("✅ $docName dökümanı başarıyla oluşturuldu.");
    } catch (e) {
      print("❌ Firebase Yazma Hatası: $e");
      _uyariVer('warning_db_error'.tr());
    }
  }

  void showModal(BuildContext context) {
    showDialog(
      barrierColor: const Color.fromARGB(64, 156, 158, 169),
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Color.fromARGB(255, 250, 251, 251),
          title: Text(
            'add_student_title'.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            width: 500,
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BuildTextFormField(
                        color: Colors.black87,
                        width: 350,
                        text: 'student_number'.tr(),
                        icon: Icons.person_2_outlined,
                        suffix: false,
                        controller: numaraController,
                        isDark: false,
                        inputtype: TextInputType.numberWithOptions(),
                        validator: null,
                      ),
                      IconButton(
                        onPressed: () async {
                          String numara = numaraController.text;
                          ogrenci = await ogrenciDokumaniniGetir(numara);
                          setState(() {});
                        },
                        icon: Icon(Icons.search),
                      ),
                    ],
                  ),
                  if (ogrenci != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 20,
                        left: 20,
                        bottom: 10,
                      ),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 220, 233, 221),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Spacer(flex: 1),
                            Column(
                              children: [
                                Text('${ogrenci?['ogr_no']}'),
                                Text(
                                  '${ogrenci?['isim']} ${ogrenci?['soyisim']}',
                                ),
                              ],
                            ),
                            Spacer(flex: 10),
                            BuildButton(
                              color: Colors.green,
                              onTop: () async {
                                List<String> dersKodlari = [];

                                for (var element in secilenDersler) {
                                  List<String> parts = element.split("-");
                                  int saat = int.parse(parts[0]);
                                  int gun = int.parse(parts[1]);

                                  if (saat < tablo.length &&
                                      gun < tablo[saat].length) {
                                    var hucre = tablo[saat][gun];
                                    String? kod = hucre['dersKod'];

                                    if (kod == null || kod.isEmpty) {
                                      _uyariVer(
                                        'warning_no_lesson_in_cell_detail'.tr(
                                          namedArgs: {
                                            'saat': saat.toString(),
                                            'gun': gun.toString(),
                                          },
                                        ),
                                      );
                                      return;
                                    }
                                    dersKodlari.add(kod);
                                  }
                                }

                                await yoklamayaKatilDirectly(
                                  fakulteId: ogrenci!['fakulte_id'],
                                  bolumId: ogrenci!['bolum_id'],
                                  dersKodu: dersKodlari[0],
                                  haftaNo: widget.dersHaftasi,
                                  dersSaatleri: secilenDersler,
                                  ogrenciUID: ogrenci!.id,
                                );

                                onayVer('success_student_added'.tr());

                                setState(() {
                                  numaraController.clear();
                                  ogrenci = null;
                                });
                                Navigator.pop(context);
                              },
                              width: 100,
                              text: 'add'.tr(),
                              height: 40,
                              icon: Icons.add,
                              styleColor: Colors.white,
                              column: false,
                            ),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  numaraController.clear();
                  ogrenci = null;
                });
                Navigator.pop(context);
              },
              child: Text(
                'close'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DocumentSnapshot?> ogrenciDokumaniniGetir(
    String ogrenciNumarasi,
  ) async {
    try {
      // Users koleksiyonunda ogr_no alanına göre sorgu yapıyoruz
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('ogr_no', isEqualTo: ogrenciNumarasi)
          .limit(
            1,
          ) // Aynı numaradan birden fazla olamayacağı için aramayı sınırlandırıyoruz
          .get();

      // Eğer eşleşen bir doküman bulunduysa
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first; // İlk (ve tek) dokümanı döndür
      } else {
        print("Bu numaraya ait öğrenci bulunamadı: $ogrenciNumarasi");
        return null; // Öğrenci yoksa null döndür
      }
    } catch (e) {
      print("Öğrenci sorgulanırken hata oluştu: $e");
      return null;
    }
  }

  Future<void> yoklamayaKatilDirectly({
    required String fakulteId,
    required String bolumId,
    required String dersKodu,
    required int haftaNo,
    required List<String> dersSaatleri,
    required String ogrenciUID,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('Fakulteler')
          .doc(fakulteId)
          .collection('Bolumler')
          .doc(bolumId)
          .collection('Dersler')
          .doc(dersKodu)
          .collection('Acilan_Yoklama_Oturumlari')
          .doc('hafta_$haftaNo');

      Map<String, dynamic> updates = {};

      for (String saat in dersSaatleri) {
        updates['${saat}_KatilanlarId'] = FieldValue.arrayUnion([ogrenciUID]);
      }

      await docRef.set(updates, SetOptions(merge: true));

      print("✅ Başarıyla güncellendi!");
    } catch (e) {
      print("❌ Güncelleme hatası: $e");
    }
  }
}
