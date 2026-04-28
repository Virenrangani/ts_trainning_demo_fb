import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget{
  final IconData icon;
  final String title;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title
});

  @override
  Widget build(BuildContext context) {
    late final texts = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(icon,size: 30,),
      title: Text(title,style: texts.headlineLarge,),
    );
  }
}