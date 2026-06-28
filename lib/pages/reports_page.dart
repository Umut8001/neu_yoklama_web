import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_yoklama_web/widgets/drawerTextButton.dart';
import 'package:qr_yoklama_web/widgets/studentsListWidget/studentItem.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportsPage extends StatefulWidget {
  String userUID;
  List<QueryDocumentSnapshot>? dersler;
  ReportsPage({super.key, required this.userUID, required this.dersler});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Map<String, dynamic>> dersListesi = [];
  List<String> idListesi = [];
  List<StudentItem> oAnkiOgrenciListesi = [];
  List<Map<String, dynamic>> oAnkipdfOgrenciListesi = [];
  String sezon = '', seciliDers = '', seciliDersId = '';

  @override
  void initState() {
    decodeDersler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Divider(height: 3),
            Container(
              // Arka plan kutusu minimum bir yüksekliğe sahip olsun
              constraints: BoxConstraints(minHeight: height),
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: AlignmentGeometry.centerRight,
                  image: AssetImage("assets/images/arkaPlanLogo.png"),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.02,
                  vertical: 24,
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'lesson_reports'.tr(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoSlab(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 5, 50, 87),
                        letterSpacing: 2.0,
                        fontSize: (width / 50).clamp(
                          20.0,
                          40.0,
                        ), // Yazı çok küçülmesin veya büyümesin
                      ),
                    ),
                    Text(
                      'lesson_reports_hint'.tr(),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: GoogleFonts.robotoSlab(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(170, 5, 50, 87),
                        letterSpacing: 2.0,
                        fontSize: (width / 100).clamp(12.0, 18.0),
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(
                      height: 3,
                      indent: width * 0.2, // Sabit 320 yerine dinamik indent
                      endIndent: width * 0.2,
                      color: const Color.fromARGB(170, 5, 50, 87),
                    ),
                    SizedBox(height: 40),

                    // ÇÖZÜM BURADA: Row yerine Wrap kullandık
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20, // Yan yana iken aralarındaki boşluk
                      runSpacing: 20, // Alt alta geçince aralarındaki boşluk
                      children: [
                        // --- SOL MENÜ KUTUSU ---
                        Container(
                          height: 600,
                          width:
                              300, // Bu zaten yeterince küçük, sabit kalabilir
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
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'lessons'.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(color: Colors.white24),
                              Row(
                                children: [
                                  SizedBox(width: 20),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'lesson_code'.tr(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'lesson_name'.tr(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Scroll eklendi ki ders sayısı artarsa menü taşmasın
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: dersListesi.map((
                                      Map<String, dynamic> hucre,
                                    ) {
                                      return TextButton(
                                        onPressed: () {
                                          setState(() {
                                            sezon =
                                                '${hucre['yil']} ${(hucre['sezon'] as String).toUpperCase()} Dönemi';
                                            seciliDers = hucre['dersAd'];
                                            seciliDersId = hucre['dersId'];
                                            ogrenciListesiYap();
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                hucre['dersId'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize:
                                                      seciliDersId ==
                                                          hucre['dersId']
                                                      ? 14
                                                      : 13.5,
                                                  color:
                                                      seciliDersId ==
                                                          hucre['dersId']
                                                      ? Colors.white
                                                      : Colors.white60,
                                                  fontWeight:
                                                      seciliDersId ==
                                                          hucre['dersId']
                                                      ? FontWeight.bold
                                                      : FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                hucre['dersAd'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize:
                                                      seciliDersId ==
                                                          hucre['dersId']
                                                      ? 14
                                                      : 13.5,
                                                  color:
                                                      seciliDersId ==
                                                          hucre['dersId']
                                                      ? Colors.white
                                                      : Colors.white60,
                                                  fontWeight:
                                                      seciliDersId ==
                                                          hucre['dersId']
                                                      ? FontWeight.bold
                                                      : FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // --- SAĞ TABLO KUTUSU ---
                        Container(
                          height: 600,
                          // ÇÖZÜM: Genişlik 1000'den küçükse ekranın %95'ini al
                          width: width < 1050 ? width * 0.95 : 1000,
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
                              ],
                            ),
                          ),
                          // ÇÖZÜM: Tablo sıkışmasın diye yatay kaydırma eklendi
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width:
                                  1000, // İçerik her zaman 1000 genişliğinde kalsın, daralırsa scroll çıksın
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 20),
                                      Text(
                                        seciliDers,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        sezon,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width:
                                            250, // 300'den 250'ye çektim, buton fazla yer kaplıyordu
                                        child: Center(
                                          child: BuildDrawerButton(
                                            text: 'download_pdf'.tr(),
                                            icon: Icons.download_outlined,
                                            textColor: Colors.white,
                                            iconColor: Colors.white,
                                            onTop: () {
                                              setState(() {
                                                pdfOlusturVeIndir();
                                              });
                                            },
                                            fontW: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                  Divider(color: Colors.white24),
                                  Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          'student_no'.tr(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          'name_surname'.tr(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'attendance'.tr(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'total_lessons'.tr(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'missed_lessons'.tr(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'absent_lessons'.tr(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'attendance_rate'.tr(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: oAnkiOgrenciListesi,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 3),
            Container(width: width, height: height / 3, color: Colors.black38),
          ],
        ),
      ),
    );
  }

  void decodeDersler() {
    dersListesi.clear();
    for (var doc in widget.dersler!) {
      String dersId = doc.id;

      final data = doc.data() as Map<String, dynamic>;
      String dersAd = data['ders_ad'];
      String sezon = data['sezon'];
      String yil = data['yil'];
      int islenen_ders_sayisi = data['islenen_ders_saati'];
      Map<String, int> ogrenciler = Map<String, int>.from(
        data['ogrenci_listesi'] ?? [],
      );
      List<String> idler = ogrenciler.keys.toList();
      debugPrint(ogrenciler.toString());
      Map<String, dynamic> element = {
        'dersId': dersId,
        'dersAd': dersAd,
        'sezon': sezon,
        'yil': yil,
        'ogrenciler': idler,
        'ogrenci_devamsizlik': ogrenciler,
        'islenen_ders_saati': islenen_ders_sayisi,
      };

      dersListesi.add(element);
    }

    print(dersListesi);
  }

  void ogrenciListesiYap() async {
    setState(() {
      oAnkiOgrenciListesi = [];
    });

    Map<String, dynamic>? seciliDersVerisi;
    QueryDocumentSnapshot?
    seciliDersDoc; // Alt koleksiyona ulaşmak için referans

    for (var doc in widget.dersler!) {
      if (doc.id == seciliDersId) {
        seciliDersDoc = doc;
        // Ders verisini mevcut listeden al
        for (var element in dersListesi) {
          if (element['dersId'] == seciliDersId) {
            seciliDersVerisi = element;
            break;
          }
        }
        break;
      }
    }

    if (seciliDersVerisi == null || seciliDersDoc == null) return;

    List<String> idler = seciliDersVerisi['ogrenciler'];

    // --- PDF'TEKI DOGRU MANTIK: Alt koleksiyondan gercek verileri cek ---
    final oturumlarRef = seciliDersDoc.reference.collection(
      'Acilan_Yoklama_Oturumlari',
    );
    final oturumlarSnapshot = await oturumlarRef.get();

    int gercekToplamDersSaati = 0;
    Map<String, int> gercekDevamsizliklar = {}; // UID -> Katıldığı Ders Sayısı

    for (var haftaDoc in oturumlarSnapshot.docs) {
      final haftaData = haftaDoc.data() as Map<String, dynamic>;

      haftaData.forEach((key, value) {
        if (key.endsWith('_KatilanlarId') && value is List) {
          gercekToplamDersSaati++; // Her yeni oturum bulunduğunda işlenen ders sayısını 1 artır

          for (var katilanUid in value) {
            // Katılan öğrencinin sayacını 1 artır
            gercekDevamsizliklar[katilanUid] =
                (gercekDevamsizliklar[katilanUid] ?? 0) + 1;
          }
        }
      });
    }
    // ----------------------------------------------------------------------

    List<Future<DocumentSnapshot?>> futures = idler
        .map((id) => getUserDoc(id))
        .toList();

    List<DocumentSnapshot?> snapshots = await Future.wait(futures);

    List<StudentItem> geciciListe = [];
    oAnkipdfOgrenciListesi.clear(); // Listeyi temizle ki üst üste binmesin

    for (var doc in snapshots) {
      if (doc != null && doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        String uid = doc.id;

        String ad = data['isim'] ?? '';
        String soyad = data['soyisim'] ?? '';
        String numara = data['ogr_no'] ?? '';

        // Statik veri yerine, dinamik hesaplanan veriyi kullanıyoruz
        int katilinanDers = gercekDevamsizliklar[uid] ?? 0;

        geciciListe.add(
          StudentItem(
            numara: numara,
            ad_soyad: '$ad $soyad',
            katilinan_ders: katilinanDers,
            gerceklesen_ders: gercekToplamDersSaati,
            eksik_ders: gercekToplamDersSaati - katilinanDers,
            katilim: 'ZORUNLU',
          ),
        );

        oAnkipdfOgrenciListesi.add({
          'isim': data['isim'] ?? '',
          'soyisim': data['soyisim'] ?? '',
          'ogr_no': data['ogr_no'] ?? '',
        });
      }
    }

    setState(() {
      oAnkiOgrenciListesi = geciciListe;
    });
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

  Future<void> pdfOlusturVeIndir() async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    // 1. Seçili dersin verilerini ve dokümanını bul
    Map<String, dynamic>? seciliDersVerisi;
    for (var element in dersListesi) {
      if (element['dersId'] == seciliDersId) {
        seciliDersVerisi = element;
        break;
      }
    }
    if (seciliDersVerisi == null) return;

    QueryDocumentSnapshot? seciliDersDoc;
    for (var doc in widget.dersler!) {
      if (doc.id == seciliDersId) {
        seciliDersDoc = doc;
        break;
      }
    }
    if (seciliDersDoc == null) return;

    // --- YENİ EKLEMELER: Başlık Bilgilerini Veritabanından Çekme ---
    final dersData = seciliDersDoc.data() as Map<String, dynamic>;

    // Öğretmen ismini Users koleksiyonundan çekiyoruz
    String ogretmenId = dersData['ogretmen_id'] ?? '';
    DocumentSnapshot? teacherDoc = await getUserDoc(ogretmenId);
    String ogretmenAdi = (teacherDoc != null && teacherDoc.exists)
        ? "${teacherDoc.get('isim')} ${teacherDoc.get('soyisim')}"
        : "---";

    // Bölüm ismini (Program) bağlı olduğu üst dokümandan (O11) çekiyoruz
    DocumentSnapshot bolumDoc = await seciliDersDoc.reference.parent.parent!
        .get();
    String programAdi = bolumDoc.exists ? bolumDoc.get('bolum_isim') : "---";
    // -----------------------------------------------------------

    final oturumlarRef = seciliDersDoc.reference.collection(
      'Acilan_Yoklama_Oturumlari',
    );
    final oturumlarSnapshot = await oturumlarRef.get();

    Map<String, List<Map<String, dynamic>>> haftaOturumMap = {};

    for (var haftaDoc in oturumlarSnapshot.docs) {
      final haftaAd = haftaDoc.id;
      final haftaData = haftaDoc.data() as Map<String, dynamic>;

      List<Map<String, dynamic>> oturumlar = [];

      haftaData.forEach((key, value) {
        if (key.endsWith('_KatilanlarId') && value is List) {
          String saatGun = key.replaceAll('_KatilanlarId', '');
          oturumlar.add({
            'saatGun': saatGun,
            'katilanlar': List<String>.from(value),
          });
        }
      });

      oturumlar.sort((a, b) {
        List<String> partsA = (a['saatGun'] as String).split('-');
        List<String> partsB = (b['saatGun'] as String).split('-');
        int saatA = int.tryParse(partsA[0]) ?? 0;
        int saatB = int.tryParse(partsB[0]) ?? 0;
        if (saatA != saatB) return saatA.compareTo(saatB);
        int gunA = int.tryParse(partsA.length > 1 ? partsA[1] : '0') ?? 0;
        int gunB = int.tryParse(partsB.length > 1 ? partsB[1] : '0') ?? 0;
        return gunA.compareTo(gunB);
      });

      if (oturumlar.isNotEmpty) {
        haftaOturumMap[haftaAd] = oturumlar;
      }
    }

    List<String> sortedHaftalar = haftaOturumMap.keys.toList()
      ..sort((a, b) {
        int numA = int.tryParse(a.replaceAll('hafta_', '')) ?? 0;
        int numB = int.tryParse(b.replaceAll('hafta_', '')) ?? 0;
        return numA.compareTo(numB);
      });

    List<String> idler = seciliDersVerisi['ogrenciler'] as List<String>;
    List<Future<DocumentSnapshot?>> futures = idler
        .map((id) => getUserDoc(id))
        .toList();
    List<DocumentSnapshot?> snapshots = await Future.wait(futures);

    Map<int, pw.TableColumnWidth> columnWidths = {
      0: const pw.FlexColumnWidth(1.5),
      1: const pw.FlexColumnWidth(5),
      2: const pw.FlexColumnWidth(12),
    };
    for (int i = 0; i < sortedHaftalar.length; i++) {
      columnWidths[i + 3] = const pw.FlexColumnWidth(3);
    }

    List<String> headers = ['#', 'Öğrenci No', 'Adı Soyadı'];
    for (var hafta in sortedHaftalar) {
      int haftaNo = int.tryParse(hafta.replaceAll('hafta_', '')) ?? 0;
      headers.add('H$haftaNo');
    }

    // İkon Widgetları
    pw.Widget tikWidget() => pw.CustomPaint(
      size: const PdfPoint(6, 6),
      painter: (canvas, size) {
        canvas
          ..setStrokeColor(PdfColors.green700)
          ..setLineWidth(1.0)
          ..moveTo(1, 3)
          ..lineTo(2.5, 1)
          ..lineTo(5, 5)
          ..strokePath();
      },
    );

    pw.Widget carpiWidget() => pw.CustomPaint(
      size: const PdfPoint(6, 6),
      painter: (canvas, size) {
        canvas
          ..setStrokeColor(PdfColors.red700)
          ..setLineWidth(1.0)
          ..moveTo(1.5, 1.5)
          ..lineTo(4.5, 4.5)
          ..strokePath()
          ..moveTo(4.5, 1.5)
          ..lineTo(1.5, 4.5)
          ..strokePath();
      },
    );

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(15),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 2,
              child: pw.Center(
                child: pw.Text(
                  "DERS YOKLAMA RAPORU",
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        "Üniversite: Necmettin Erbakan Üniversitesi",
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        "Ders Kodu: $seciliDersId",
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        "Ders Adı: $seciliDers",
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        "Program: $programAdi",
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        "Dönem: $sezon",
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        "Öğretim Elemanı: $ogretmenAdi",
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Table(
              columnWidths: columnWidths,
              border: pw.TableBorder.all(width: 0.5),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: headers
                      .map(
                        (h) => pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(
                            h,
                            style: pw.TextStyle(
                              fontSize: 6,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      )
                      .toList(),
                ),
                ...List.generate(idler.length, (index) {
                  final doc = snapshots[index];
                  if (doc == null || !doc.exists)
                    return pw.TableRow(children: []);

                  final data = doc.data() as Map<String, dynamic>;
                  String uid = doc.id;

                  List<pw.Widget> hucreler = [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        (index + 1).toString(),
                        style: const pw.TextStyle(fontSize: 6),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        data['ogr_no'] ?? '',
                        style: const pw.TextStyle(fontSize: 6),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        "${data['isim']} ${data['soyisim']}",
                        style: const pw.TextStyle(fontSize: 6),
                      ),
                    ),
                  ];

                  for (var hafta in sortedHaftalar) {
                    List<Map<String, dynamic>> oturumlar =
                        haftaOturumMap[hafta] ?? [];
                    if (oturumlar.isEmpty) {
                      hucreler.add(
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(
                            '-',
                            style: const pw.TextStyle(fontSize: 6),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      hucreler.add(
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Wrap(
                            spacing: 1,
                            children: oturumlar
                                .map(
                                  (o) => (o['katilanlar'] as List).contains(uid)
                                      ? tikWidget()
                                      : carpiWidget(),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    }
                  }
                  return pw.TableRow(children: hucreler);
                }).where((row) => row.children!.isNotEmpty).toList(),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
