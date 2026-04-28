import 'package:ts_training_demo_fb/feature/auth/domain/entity/login_entity.dart';
import 'package:ts_training_demo_fb/feature/auth/domain/repository/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;
  LoginUseCase(this.repository);

  Future<LoginEntity> loginCall(String email,String password){
    return repository.login(email, password);
  }

  Future<LoginEntity> googleCall(){
    return repository.signInWithGoogle();
  }

  Future<LoginEntity> githubCall(){
    return repository.signInWithGithub();
  }
}