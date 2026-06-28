import 'package:flutter/material.dart';

class BuildDrawerButton extends StatelessWidget {
  String text;
  IconData icon;
  Color textColor;
  Color iconColor;

  VoidCallback onTop;
  FontWeight fontW;

  BuildDrawerButton({
    super.key,
    required this.text,
    required this.icon,
    required this.textColor,
    required this.iconColor,
    required this.onTop,
    required this.fontW,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5), // Dış boşluk
      child: TextButton(
        onPressed: onTop,
        child: Row(
          mainAxisSize: MainAxisSize
              .min, // ÇÖZÜM 1: Buton sadece içindeki yazı kadar yer kaplasın
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: fontW == FontWeight.bold ? height / 40 : height / 50,
            ),
            SizedBox(
              width: 8,
            ), // ÇÖZÜM 2: 20 çok fazlaydı, 8 piksel yeterli boşluğu verir.
            Flexible(
              child: Text(
                text,
                style: TextStyle(color: textColor, fontWeight: fontW),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Spacer()'ı tamamen kaldırdık, çünkü üst menüde kutuyu patlatıyordu.
          ],
        ),
      ),
    );
  }
}
