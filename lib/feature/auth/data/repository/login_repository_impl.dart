import 'package:ts_training_demo_fb/feature/auth/data/data_source/data_source.dart';
import 'package:ts_training_demo_fb/feature/auth/domain/entity/login_entity.dart';
import 'package:ts_training_demo_fb/feature/auth/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository{
  final LoginDataSource loginDataSource;
  LoginRepositoryImpl(this.loginDataSource);

  @override
  Future<LoginEntity> login(String email, String password) async{
    final model= await loginDataSource.login(email, password);
    return LoginEntity(
      id: model.id,
      email: model.email
    );
  }

  @override
  Future<LoginEntity> signInWithGoogle() async{
    final user= await loginDataSource.signInWithGoogle();
    return LoginEntity(id: user.id, email: user.email);
  }

  @override
  Future<LoginEntity> signInWithGithub() async{
    final user=await loginDataSource.signInWithGithub();
    return LoginEntity(id: user.id, email: user.email);
  }
}