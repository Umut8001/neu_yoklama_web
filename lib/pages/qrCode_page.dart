import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodePage extends StatefulWidget {
  String sifre;
  String kisaSifre;
  QrcodePage({super.key, required this.sifre, required this.kisaSifre});

  @override
  State<QrcodePage> createState() => _QrcodePageState();
}

double xPosition = 100.0;
double yPosition = 100.0;

double qrSize = 400;

class _QrcodePageState extends State<QrcodePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String qrData = widget.sifre;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Slider(
            activeColor: Colors.black,
            max: width / 2,
            min: width / 10,
            value: qrSize,
            onChanged: (value) {
              setState(() {
                qrSize = value;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: xPosition,
            top: yPosition,
            child: GestureDetector(
              // Sürükleme hareketi güncellendiğinde tetiklenir
              onPanUpdate: (details) {
                setState(() {
                  // Mevcut pozisyona sürükleme miktarını (delta) ekliyoruz
                  xPosition += details.delta.dx;
                  yPosition += details.delta.dy;
                });
              },
              child: Column(
                children: [
                  QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: qrSize,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,

                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape
                          .circle, // Gözleri yuvarlak yapmak odaklanmayı artırabilir
                      color: Color(0xFF000000),
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape
                          .circle, // Pikselleri yuvarlak yaparak logoyla karışmasını önle
                      color: Color(0xFF000000),
                    ),
                  ),
                  Text(
                    '${'qr_code_label'.tr()}: ${widget.kisaSifre}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width / 80,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
