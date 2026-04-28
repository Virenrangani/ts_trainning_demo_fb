import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ts_training_demo_fb/feature/auth/data/model/login_model.dart';

abstract class LoginDataSource{
  Future<LoginModel> login(String email,String password);

  Future<LoginModel> signInWithGoogle();

  Future<LoginModel> signInWithGithub();
}

class LoginDataSourceImpl implements LoginDataSource {
  final FirebaseAuth firebaseAuth;

  LoginDataSourceImpl(this.firebaseAuth);

  @override
  Future<LoginModel> login(String email, String password) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return LoginModel.fromFirebase(result.user!);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }


  @override
  Future<LoginModel> signInWithGoogle() async{
    await GoogleSignIn().signOut();
    final googleUser=await GoogleSignIn().signIn();

    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential=await firebaseAuth.signInWithCredential(credential);

    final user=userCredential.user;
    if(user == null){
      throw Exception("user is not found");
    }
    return LoginModel.fromFirebase(userCredential.user!);
  }


  @override
  Future<LoginModel> signInWithGithub()async {

    GithubAuthProvider githubProvider=GithubAuthProvider();

    final UserCredential credential=await firebaseAuth
        .signInWithProvider(githubProvider);

    final user=credential.user;

    if (user==null){
      throw Exception("User is not created");
    }
    return LoginModel.fromFirebase(user);
  }
}
