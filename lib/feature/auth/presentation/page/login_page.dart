import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_training_demo_fb/core/validation/email_password_validation/email_password_validation.dart';
import 'package:ts_training_demo_fb/core/widget/elevated_button/custom_elevated_button.dart';
import 'package:ts_training_demo_fb/core/widget/inkwell_button/custom_inkwell_button.dart';
import 'package:ts_training_demo_fb/core/widget/snack_bar/custom_snack_bar.dart';
import 'package:ts_training_demo_fb/feature/auth/data/data_source/data_source.dart';
import 'package:ts_training_demo_fb/feature/auth/data/repository/login_repository_impl.dart';
import '../../../../core/widget/text_form_field/custom_text_form_field.dart';
import '../../../../pages/bottom_navbar/bottom_nav_bar.dart';
import '../../../../pages/signup/pages/sign_up_page.dart';
import '../../domain/usecase/login_use_case.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginCubit _loginCubit;
  String? emailError;
  String? passwordError;

  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  @override
  void initState(){
    super.initState();
    _loginCubit=LoginCubit(
        LoginUseCase(
            LoginRepositoryImpl(
                LoginDataSourceImpl(FirebaseAuth.instance)
            )
        )
    );
  }
  @override
  void dispose(){
    _loginCubit.close();
    super.dispose();
  }

  void changedEmail(String value){
    setState(() {
      emailError=validateEmail(value);
    });
  }
  void changedPassword(String value){
    setState(() {
      passwordError=validatePassword(value);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text("Login " ),
          centerTitle: true,
        ),
        body: BlocProvider.value(
          value: _loginCubit,
          child: BlocConsumer<LoginCubit,LoginState>(
            listener: (context,state){

              if (state is LoginSuccess){
                CustomSnacksBar.showSuccess(context, "Login Successfully ");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BottomNav(),
                    ),
                        (route)=>false
                );
              }
              if (state is LoginFailure){
                CustomSnacksBar.showError(context, state.message);
              }
            },
            builder: (context, state){
              return Container(
                padding: EdgeInsets.all(25),
                child: Form(
                  key: _formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      CustomFormField(
                          controller: emailController,
                          labelText: "E-mail",
                          hintText: "Enter Mail",
                          prefixIcon: Icons.mail_lock_outlined,
                          onChanged: changedEmail,
                          validator: (_)=>emailError
                      ),
                      SizedBox(height: 20,),
                      CustomFormField(
                          controller: passwordController,
                          labelText: "Password",
                          hintText: "Enter Password",
                          prefixIcon: Icons.password_outlined,
                          obscureText: true,
                          onChanged: changedPassword,
                          validator:(_)=>passwordError
                      ),
                      SizedBox(height: 30,),
                      state is LoginLoading ? CircularProgressIndicator():
                      CustomElevatedButton(
                          isLoading: state is LoginLoading,
                          onPressed: ()async{
                            if(_formkey.currentState!.validate()){
                              context.read<LoginCubit>().login(
                                  emailController.text,
                                  passwordController.text
                              );
                            }
                            await FirebaseAnalytics.instance.logLogin(
                                loginMethod: "E-mail"
                            );
                          },
                          text: "Login",
                      ),
                      SizedBox(height: 35,),
                      CustomInkwellButton(
                          text: "Don't have an account ",
                          isGradient: true,
                          onTap:(){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                          }
                      ),
                      SizedBox(height: 8,),
                      CustomInkwellButton(
                          text: "Sign in using Google",
                          isGradient: true,
                          onTap: () {
                            context.read<LoginCubit>().signInWithGoogle();
                          },
                      ),
                      SizedBox(height: 8,),
                      CustomInkwellButton(
                        text: "Sign in using Github",
                        isGradient: true,
                        onTap: () {
                          context.read<LoginCubit>().signInWithGithub();
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
    );
  }
}
