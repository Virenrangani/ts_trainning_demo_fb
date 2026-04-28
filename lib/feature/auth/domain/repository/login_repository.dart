
import 'package:ts_training_demo_fb/feature/auth/domain/entity/login_entity.dart';

abstract class LoginRepository {
  Future<LoginEntity> login(String email,String password);

  Future<LoginEntity> signInWithGoogle();

  Future<LoginEntity> signInWithGithub();
}