import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dashboard/page/dashboard.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';

class CustomAlertDialog extends StatelessWidget{

  const CustomAlertDialog({
    super.key,
});

  @override
  Widget build(BuildContext context) {
    final bloc=context.read<SignupBloc>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(30)),
      backgroundColor: Colors.deepPurpleAccent,
      title: Row(
        children: [
          Text("Hello ${bloc.name}",style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white),),
          SizedBox(width: 7,),
          Icon(Icons.handshake_outlined , color: Colors.white,)
        ],
      ),
      content: Text("Email:${bloc.email} && Password:${bloc.password}",
        style: TextStyle(fontSize: 20,color: Colors.white),),
      actions: [
        ElevatedButton(onPressed: (){
          bloc.add(ConfirmSignUp());
          Navigator.push(
             context,
             MaterialPageRoute(
                builder: (_)=>Dashboard()
               ),
          );
        },
          child: Text("Confirm",style: TextStyle(fontSize: 20,color: Colors.black),),
        )
      ],
    );
  }}