import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_yoklama_web/widgets/lessonstableWidgets/table.dart';

class LessonSelectionPage extends StatefulWidget {
  var dersler;
  final String userUID;
  int dersHaftasi;
  GeoPoint konum;
  LessonSelectionPage({
    super.key,
    required this.userUID,
    required this.dersler,
    required this.dersHaftasi,
    required this.konum,
  });

  @override
  State<LessonSelectionPage> createState() => _LessonSelectionPageState();
}

class _LessonSelectionPageState extends State<LessonSelectionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool mobile = width >= height ? false : true;
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Column(
          children: [
            const Divider(height: 3),
            Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.centerRight,
                  image: AssetImage("assets/images/arkaPlanLogo.png"),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: mobile ? 2 : width / 5.7,
                  vertical: height / 80,
                ),
                padding: EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'welcome'.tr(),
                      style: GoogleFonts.robotoSlab(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 5, 50, 87),
                        letterSpacing: 2.0,
                        fontSize: width / 50,
                      ),
                    ),
                    Text(
                      'select_lesson_hint'.tr(),
                      style: GoogleFonts.robotoSlab(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(170, 5, 50, 87),
                        letterSpacing: 2.0,
                        fontSize: height / 60,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      height: 3,
                      indent: 320,
                      endIndent: 320,
                      color: Color.fromARGB(170, 5, 50, 87),
                    ),
                    const SizedBox(height: 40),

                    Center(
                      child: LessonTable(
                        userUID: widget.userUID,
                        dersler: widget.dersler,
                        dersHaftasi: widget.dersHaftasi,
                        konum: widget.konum,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 3),
            Container(width: width, height: height / 3, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
