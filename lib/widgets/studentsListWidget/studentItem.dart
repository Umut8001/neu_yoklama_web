import 'package:flutter/material.dart';

class StudentItem extends StatefulWidget {
  String numara, ad_soyad, katilim;
  int gerceklesen_ders, katilinan_ders, eksik_ders;
  StudentItem({
    super.key,
    required this.numara,
    required this.ad_soyad,
    required this.eksik_ders,
    required this.gerceklesen_ders,
    required this.katilim,
    required this.katilinan_ders,
  });

  @override
  State<StudentItem> createState() => _StudentItemState();
}

class _StudentItemState extends State<StudentItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: (widget.katilim == 'ZORUNLU' && widget.eksik_ders >= 5)
          ? Colors.red
          : Colors.transparent,
      child: Row(
        children: [
          SizedBox(width: 20),
          Expanded(
            flex: 4,
            child: Text(
              widget.numara,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),

          Expanded(
            flex: 4,
            child: Text(
              widget.ad_soyad,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              widget.katilim,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              widget.gerceklesen_ders.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              widget.katilinan_ders.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              widget.eksik_ders.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              overflow: TextOverflow.ellipsis,
              '%' +
                  ((((widget.gerceklesen_ders - widget.eksik_ders) /
                                  widget.gerceklesen_ders) *
                              100)
                          .toInt())
                      .toString(),
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
