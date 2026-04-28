class SignupEvent {}

class SignupRequested extends SignupEvent {
  final String name;
  final String email;
  final String password;

  SignupRequested({
    required this.email,
    required this.password,
    required this.name
  });
}
class ConfirmSignUp extends SignupEvent{}