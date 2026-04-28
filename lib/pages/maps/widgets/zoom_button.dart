import 'package:flutter/material.dart';

Widget zoomButton(IconData icon,VoidCallback onPressed){
  return Material(
    elevation: 4,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onPressed,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Color(0xffebc5e9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 28),
      ),
    ),
  );
}