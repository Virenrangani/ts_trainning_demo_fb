import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_training_demo_fb/feature/auth/domain/usecase/login_use_case.dart';
import 'package:ts_training_demo_fb/feature/auth/presentation/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState>{
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase):super(LoginInitial());

  Future<void> login(String email,String password)async{
    emit(LoginLoading());
    try{
      await loginUseCase.loginCall(email, password);
      emit(LoginSuccess());
    }catch(e){
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> signInWithGoogle()async{
    emit(LoginLoading());
    try{
      await loginUseCase.googleCall();
      emit(LoginSuccess());
    }catch(e){
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> signInWithGithub()async{
    emit(LoginLoading());
    try{
      await loginUseCase.githubCall();
      emit(LoginSuccess());
    }catch(e){
      emit(LoginFailure(e.toString()));
    }
  }
}