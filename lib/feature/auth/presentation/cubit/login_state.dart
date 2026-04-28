abstract class LoginState {}

class LoginInitial extends LoginState{}

class LoginLoading extends LoginState{}

class LoginSuccess extends LoginState{}

class LoginCodeSent extends LoginState{}

class LoginVerify extends LoginState{}

class LoginFailure extends LoginState{
  final String message;
  LoginFailure(this.message);
}