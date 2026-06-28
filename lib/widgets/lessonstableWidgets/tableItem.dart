import 'package:flutter/material.dart';

class Tableitem extends StatefulWidget {
  Color bgColor, titleColor, sbtitleColor, borderColor;
  String? title, subtitle;
  IconData? icon = null;
  Function onTap;
  List liste;
  int satir, sutun;
  Tableitem({
    super.key,
    required this.icon,
    required this.bgColor,
    required this.sbtitleColor,
    required this.titleColor,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.liste,
    required this.satir,
    required this.sutun,
  });

  @override
  State<Tableitem> createState() => _TableitemState();
}

class _TableitemState extends State<Tableitem> {
  late bool border;
  @override
  void initState() {
    super.initState();
    border = false;
  }

  @override
  void didUpdateWidget(Tableitem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.liste.contains('${widget.satir}-${widget.sutun}')) {
      border = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.title != '' ? border = !border : border = false;
            if (widget.liste.indexOf('${widget.satir}-${widget.sutun}') == -1 &&
                widget.title != '') {
              widget.liste.add('${widget.satir}-${widget.sutun}');
              border = true;
            } else {
              widget.liste.remove('${widget.satir}-${widget.sutun}');
              border = false;
            }

            //print(widget.liste);
          });
        },
        child: Container(
          width: 100,
          height: 70,
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(20),
            border: border
                ? BoxBorder.all(color: widget.borderColor, width: 1)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.title ?? '',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.titleColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.icon != null ? Icon(widget.icon) : SizedBox(),
                  Text(
                    widget.subtitle ?? '',
                    style: TextStyle(
                      color: widget.sbtitleColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
