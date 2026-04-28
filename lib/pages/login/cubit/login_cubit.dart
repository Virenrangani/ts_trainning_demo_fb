import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../signup/bloc/auth_state.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginCubit extends Cubit<AuthState>{
  LoginCubit():super(AuthInitial());

  String? verificationId;

  Future<void> login({
    required String email,
    required String password,
})async {
    emit(AuthLoading());

    try{
      final credential=await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user=credential.user;

      if(user==null){
        emit(AuthFailure("User is not created"));
        return;
      }

      if(!user.emailVerified){
        emit(AuthFailure("User is not verified"));
        return;
      }
      emit(AuthSuccess());
    }catch(e){
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {

    emit(AuthLoading());

    try {
      await signOut();
      final googleUser = await GoogleSignIn().signIn();
      print("googleUser : $googleUser");

      if (googleUser == null) {
        emit(AuthFailure("Google sign-in cancelled"));
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (userCredential.user == null) {
        emit(AuthFailure("User not found"));
        return;
      }

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure("Google login failed"));
    }
  }

  Future<void> signInWithGithub()async{

    emit(AuthLoading());
    try{
      await signOut();
      GithubAuthProvider githubProvider=GithubAuthProvider();

      final UserCredential credential=await FirebaseAuth.instance
          .signInWithProvider(githubProvider);

      final user=credential.user;

      if (user==null){
        emit(AuthFailure("User is not found"));
      }

      emit(AuthSuccess());

    }catch(e){
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> sendOtp(String phone)async{
    emit(AuthLoading());

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential)async{
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (e){
        emit(AuthFailure(e.toString()));

      },
      codeSent: (id,_){
        verificationId=id;
        emit(AuthCodeSent());
      },
        codeAutoRetrievalTimeout: (_){}
    );
  }

  Future<void> verifyOtp(String otp)async{
    emit(AuthLoading());

    try{
      final credential=PhoneAuthProvider.credential(
          verificationId: verificationId!,
          smsCode: otp
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(AuthSuccess());
    }catch(e){
      print(e.toString());
      emit(AuthFailure(e.toString()));
    }
  }
  Future<void> signOut()async{
    await FirebaseAuth.instance.signOut();
  }
}

