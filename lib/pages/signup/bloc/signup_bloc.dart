import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_training_demo_fb/pages/signup/bloc/signup_event.dart';
import '../../signup/bloc/auth_state.dart';
import '../../storage/sharedpreference_helper.dart';


class SignupBloc extends Bloc<SignupEvent, AuthState> {
  String? name;
  String? email;
  String? password;
  SignupBloc() : super(AuthInitial()) {
    on<SignupRequested>(_onSubmit);
    on<ConfirmSignUp>(_onSignup);
  }

    void _onSubmit(SignupRequested event, Emitter<AuthState> emit) async {
    name=event.name;
    email=event.email;
    password=event.password;

    emit(AuthLoading());
    try{
      UserCredential credential=
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              email: event.email,
              password: event.password
          );
      final user= credential.user;

      if (user!=null && !user.emailVerified){
        await user.sendEmailVerification();
      }
      emit(AuthVerify());
    }catch(e){
      emit(AuthFailure(e.toString()));
    }
  }
  void _onSignup(ConfirmSignUp event, Emitter<AuthState> emit)async {
    emit(AuthLoading());

    final user=FirebaseAuth.instance.currentUser;
    if(user==null){
      emit(AuthFailure("User is not found"));
    }
    if (user!=null&& !user.emailVerified){
      await  SharedPreferenceHelper.saveUser(
        name: name!,
        email: email!,
        password: password!,
      );
      emit(AuthSuccess());
    }else{
      emit(AuthFailure("Still Not Verified "));
    }
  }
}
