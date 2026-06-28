import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_yoklama_web/pages/lesson_selection_page.dart';
import 'package:qr_yoklama_web/pages/reports_page.dart';
import 'package:qr_yoklama_web/pages/sign_in_page.dart';

import 'package:qr_yoklama_web/widgets/drawerTextButton.dart';
import 'package:qr_yoklama_web/widgets/lessonstableWidgets/table.dart';

class HomePage extends StatefulWidget {
  String userUID;
  HomePage({super.key, required this.userUID});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FontWeight fw1, fw2, fw3, fw4;
  late int page;
  DocumentSnapshot? userDoc;
  List<QueryDocumentSnapshot>? dersler;
  bool isLoading = true;
  late List<Widget> pages;
  late int dersHaftasi;
  late GeoPoint konum;

  @override
  void initState() {
    fw1 = FontWeight.bold;
    fw2 = fw3 = fw4 = FontWeight.normal;
    page = 0;
    initData();
    getHaftandKonum();

    super.initState();
  }

  Future<void> initData() async {
    try {
      DocumentSnapshot? doc = await getUserDoc(widget.userUID);
      List<QueryDocumentSnapshot> dersList = await getTumDersler(
        widget.userUID,
      );

      if (mounted) {
        setState(() {
          userDoc = doc;
          dersler = dersList;
          isLoading = false;
          for (var doc in dersler!) {
            print(doc.data());
            print(doc['ders_takvimi'].toString());
          }
        });
      }
    } catch (e) {
      print("Hata: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 161, 201),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    pages = [
      LessonSelectionPage(
        konum: konum,
        userUID: widget.userUID,
        dersler: dersler,
        dersHaftasi: dersHaftasi,
      ),
      ReportsPage(userUID: widget.userUID, dersler: dersler),
      SizedBox(),
    ];

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 161, 201),
      drawer: width >= height
          ? null
          : Drawer(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Image.asset("assets/images/neu.png", width: width / 15),
                      SizedBox(height: 10),
                      Text(
                        '${userDoc?.get('isim') ?? ""} ${userDoc?.get('soyisim') ?? ""}',
                        style: GoogleFonts.robotoSlab(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 2.0,
                          fontSize: width / 100,
                        ),
                      ),
                      Divider(indent: 15, endIndent: 15),
                      SizedBox(height: 10),
                      Text(
                        'Hafta: ${dersHaftasi.toString()}',
                        style: GoogleFonts.robotoSlab(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: width / 50,
                        ),
                      ),
                      BuildDrawerButton(
                        text: 'home'.tr(),
                        icon: Icons.home_outlined,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        fontW: fw1,
                        onTop: () {
                          setState(() {
                            fw1 = FontWeight.bold;
                            fw2 = fw3 = fw4 = FontWeight.normal;
                            page = 0;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      BuildDrawerButton(
                        text: 'reports_and_lists'.tr(),
                        icon: Icons.insert_chart_outlined_sharp,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        fontW: fw2,
                        onTop: () {
                          setState(() {
                            fw2 = FontWeight.bold;
                            fw1 = fw3 = fw4 = FontWeight.normal;
                            page = 1;
                          });
                        },
                      ),

                      SizedBox(height: 10),
                      BuildDrawerButton(
                        text: 'settings'.tr(),
                        icon: Icons.settings_outlined,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        fontW: fw4,
                        onTop: () {
                          setState(() {
                            fw4 = FontWeight.bold;
                            fw2 = fw3 = fw1 = FontWeight.normal;
                            page = 3;
                          });
                        },
                      ),
                    ],
                  ),

                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: BuildDrawerButton(
                      text: 'sign_out'.tr(),

                      icon: Icons.output_rounded,
                      textColor: Colors.redAccent,
                      iconColor: Colors.black,
                      onTop: () {
                        signOut();
                      },
                      fontW: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            ),
      appBar: AppBar(
        backgroundColor: width >= height
            ? const Color.fromARGB(255, 5, 50, 87)
            : Colors.transparent,
        actions: width >= height
            ? [
                Image.asset("assets/images/neu.png", width: width / 15),
                SizedBox(height: 10),
                Text(
                  '${userDoc?.get('isim') ?? ""} ${userDoc?.get('soyisim') ?? ""}',
                  style: GoogleFonts.robotoSlab(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: width / 100,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: width / 9.6,
                  child: BuildDrawerButton(
                    text: 'home'.tr(),

                    icon: Icons.home_outlined,
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    fontW: fw1,
                    onTop: () {
                      setState(() {
                        fw1 = FontWeight.bold;
                        fw2 = fw3 = fw4 = FontWeight.normal;
                        page = 0;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: width / 7,
                  child: BuildDrawerButton(
                    text: 'reports_and_lists'.tr(),
                    icon: Icons.insert_chart_outlined_sharp,
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    fontW: fw2,
                    onTop: () {
                      setState(() {
                        fw2 = FontWeight.bold;
                        fw1 = fw3 = fw4 = FontWeight.normal;
                        page = 1;
                      });
                    },
                  ),
                ),

                SizedBox(
                  width: width / 10,
                  child: BuildDrawerButton(
                    text: 'settings'.tr(),
                    icon: Icons.settings_outlined,
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    fontW: fw4,
                    onTop: () {
                      setState(() {
                        fw4 = FontWeight.bold;
                        fw2 = fw3 = fw1 = FontWeight.normal;
                        //page = 1;
                        showSettings(context);
                      });
                    },
                  ),
                ),

                Spacer(),
                Text(
                  '${'week'.tr()}: ${dersHaftasi.toString()}',
                  style: GoogleFonts.robotoSlab(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: width / 110,
                  ),
                ),
                SizedBox(
                  width: width / 10,
                  child: BuildDrawerButton(
                    text: 'sign_out'.tr(),
                    icon: Icons.output_rounded,
                    textColor: Colors.white,
                    iconColor: Colors.red,
                    onTop: () {
                      signOut();
                    },
                    fontW: FontWeight.w500,
                  ),
                ),
              ]
            : [],
      ),
      body: pages[page],
    );
  }

  Future<DocumentSnapshot?> getUserDoc(String uid) async {
    try {
      return await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot>> getTumDersler(String ogretmenUID) async {
    print(ogretmenUID);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('Dersler')
          .where('ogretmen_id', isEqualTo: ogretmenUID)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      return [];
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SignInPage()),
      (Route<dynamic> route) => false,
    );
  }

  void getHaftandKonum() async {
    final doc = await FirebaseFirestore.instance.doc('Fakulteler/100').get();
    String hafta = doc.get('ders_haftasi') ?? 'h0';
    DateTime baslangic = (doc.get('donem_baslangic') as Timestamp).toDate();

    konum = doc.get('konum');

    dersHaftasi = kacinciHaftadayiz(baslangic);

    // dersHaftasi = int.parse(hafta.split("h")[1]);
  }

  int kacinciHaftadayiz(DateTime baslangicTarihi) {
    DateTime bugun = DateTime.now();

    // İki tarih arasındaki gün farkını bul
    int fark = bugun.difference(baslangicTarihi).inDays;

    // Haftayı hesapla (7 güne böl ve 1 ekle)
    // Örn: 0-6 gün arası 1. hafta, 7-13 gün arası 2. hafta
    int hafta = (fark / 7).floor() + 1;

    // 14 haftalık sınır kontrolü
    if (hafta < 1) return 1;
    // if (hafta > 14) return 14;

    return hafta;
  }

  void showSettings(BuildContext context) {
    showDialog(
      barrierColor: const Color.fromARGB(64, 156, 158, 169),
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Color.fromARGB(255, 250, 251, 251),
          title: Text(
            'settings'.tr(),
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
                children: [
                  Row(
                    children: [
                      Spacer(flex: 10),
                      Text(
                        'language_selection'.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(flex: 1),

                      DropdownButton<Locale>(
                        value: context.locale,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.language,
                          color: Colors.blueAccent,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: Locale('tr'),
                            child: Text(
                              'Türkçe',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text(
                              'English',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                          DropdownMenuItem(
                            value: Locale('ar'),
                            child: Text(
                              'العربية',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                        onChanged: (Locale? locale) {
                          if (locale != null) context.setLocale(locale);
                        },
                      ),
                      Spacer(flex: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {});
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
}
