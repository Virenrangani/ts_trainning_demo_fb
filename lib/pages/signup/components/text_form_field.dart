import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextEditingController controller;


  const CustomFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    required this.validator,
    required this.controller,
});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
        decoration: InputDecoration(
          labelText: labelText ,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          prefixIconColor: WidgetStateColor.fromMap(<WidgetStatesConstraint, Color>{
            WidgetState.focused: Colors.green,
            WidgetState.error:Colors.red,
            WidgetState.any: Colors.grey,
          }),
        ),
        validator: validator
      );
  }
}