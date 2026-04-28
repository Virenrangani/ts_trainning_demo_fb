import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_training_demo_fb/pages/bottom_navbar/bottom_nav_bar.dart';
import 'package:ts_training_demo_fb/pages/dashboard/page/dashboard.dart';
import 'package:ts_training_demo_fb/pages/login/pages/otp_screen.dart';
import '../../signup/bloc/auth_state.dart';
import '../../signup/components/text_form_field.dart';
import '../../signup/pages/sign_up_page.dart';
import '../cubit/login_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final LoginCubit _loginCubit;
  @override
  void initState(){
    super.initState();
    _loginCubit=LoginCubit();
  }
  @override
  void dispose(){
    _loginCubit.close();
    super.dispose();
  }
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    late final colors = Theme.of(context).colorScheme;
    late final texts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Login " , style: texts.titleLarge),
        centerTitle: true,
        backgroundColor: colors.primary,
      ),
      body: BlocProvider.value(
        value: _loginCubit,
        child: BlocConsumer<LoginCubit,AuthState>(
          listener: (context,state){

            if (state is AuthSuccess){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:
                Text("Login Successfully ", style: texts.bodyMedium,),
                  backgroundColor: colors.secondary,
                )
              );
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                builder: (_) => BottomNav(),
              ),
                  (route)=>false
              );
            }
            if (state is AuthFailure){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content:Text(state.message),
                    backgroundColor: colors.secondary,
                  )
              );
            }
          },
          builder: (context, state){
            return Container(
                padding: EdgeInsets.all(25),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      CustomFormField(
                        controller: emailController,
                          labelText: "E-mail",
                          hintText: "Enter Mail",
                          prefixIcon: Icons.mail_lock_outlined,
                          validator: (val){
                          if(val!.isEmpty){
                            return "Email is required";
                          }
                          return null;
                          }

                      ),
                      SizedBox(height: 20,),
                      CustomFormField(
                        controller: passwordController,
                          labelText: "Password",
                          hintText: "Enter Password",
                          prefixIcon: Icons.password_outlined,
                          validator:(val){
                          if (val!.isEmpty){
                            return "Password is required";
                          }
                          return null;
                          }

                      ),
                      SizedBox(height: 25,),
                    state is AuthLoading ? CircularProgressIndicator():
                        ElevatedButton(
                            onPressed: () async {

                              if(_formkey.currentState!.validate()){
                                // context.read<LoginCubit>().sendOtp(emailController.text.trim());
                                context.read<LoginCubit>().login(
                                    email: emailController.text,
                                    password: passwordController.text
                                );
                              }
                               await FirebaseAnalytics.instance.logLogin(
                                  loginMethod: "E-mail"
                              );
                            },
                            child: Text("Submit")
                        ),
                    SizedBox(height: 20,),
                            InkWell(
                              onDoubleTap: (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                              },
                              child: Text("Don't have an account?",style: texts.headlineLarge,),
                            ),
                      SizedBox(height: 15,),
                      InkWell(
                        onTap: ()async{
                          await context.read<LoginCubit>().signInWithGoogle();
                          await FirebaseAnalytics.instance.logLogin(loginMethod: "google_login");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.g_mobiledata_outlined,),
                            Text("SigIn With Google")
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        onTap: ()async{
                          await context.read<LoginCubit>().signInWithGithub();
                          await FirebaseAnalytics.instance.logLogin(loginMethod: "github_login");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_outlined,),
                            Text("SigIn With github")
                          ],
                        ),
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
