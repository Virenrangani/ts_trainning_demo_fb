import 'package:flutter/material.dart';

class CustomInkwellButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final bool isGradient;

  const CustomInkwellButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.isGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Ink(
        decoration: BoxDecoration(
          gradient: isGradient
              ? LinearGradient(
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          )
              : null,
          color: isGradient ? null : (color ?? Colors.blue),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Container(
          width: MediaQuery.of(context).size.width*0.60,
          padding: EdgeInsets.symmetric(vertical:3),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}