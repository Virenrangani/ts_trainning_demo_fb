
import 'package:firebase_auth/firebase_auth.dart';

class LoginModel {
  final String id;
  final String email;

  LoginModel({
    required this.id,
    required this.email,
  });

  factory LoginModel.fromFirebase(User user) {
    return LoginModel(
      id: user.uid,
      email: user.email ?? '',
    );
  }

  Map<String , dynamic> toJson(){
    return {
      'id':id,
      "email":email,
    };
  }
}