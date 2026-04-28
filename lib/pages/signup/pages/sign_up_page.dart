import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_training_demo_fb/pages/login/pages/login_form.dart';
import '../bloc/auth_state.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../components/custom_alert_dialog.dart';
import '../components/text_form_field.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    late final colors = Theme.of(context).colorScheme;
    late final texts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp " , style:texts.titleLarge ),
        centerTitle: true,
        backgroundColor: colors.primary
      ),
      body: BlocProvider(
        create: (_)=>SignupBloc(),
        child: BlocConsumer<SignupBloc,AuthState>(
          listener: (context,state)async{
            if(state is AuthVerify){
              final signupBloc=context.read<SignupBloc>();
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context){
                    return BlocProvider(
                        create: (_)=>signupBloc,
                        child: CustomAlertDialog()
                    );
                  }
              );
              await Future.delayed(const Duration(seconds: 2));
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context,state){
            return Container(
                padding:EdgeInsets.all(20),
                child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                      CustomFormField(
                      controller: nameController,
                      labelText: "Name",
                      hintText: "Enter your Name",
                      prefixIcon: Icons.person_2_outlined, validator: (String? p1) { return null; },
                    ),
                    SizedBox(height: 30,),

                    CustomFormField(
                      controller: emailController,
                      labelText:"E-mail" ,
                      hintText: "Enter your Email",
                      prefixIcon: Icons.mail_outline,
                      validator: (value) {
                        if (value==null||value.isEmpty){
                          return "Email is Required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30,),

                    CustomFormField(
                        controller: passwordController,
                        labelText: "Password",
                        hintText: "Enter your Password",
                        prefixIcon: Icons.password_outlined,
                        validator: (value){
                          if(value!.length<5){
                            return "Enter Your Password";
                          }
                          return null;
                        }
                    ),
                    SizedBox(height: 30,),
                    state is AuthLoading ? CircularProgressIndicator() :
                        ElevatedButton(
                            onPressed: ()async{
                              if(_formkey.currentState!.validate()){
                                context.read<SignupBloc>().add(
                                  SignupRequested(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                ),
                                );
                                await FirebaseAnalytics.instance.logSignUp(
                                    signUpMethod: "email_password"
                                );
                              }
                            },
                            child: Text("Submit", style: texts.headlineLarge,)
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>LoginForm())
                            );
                          },
                            child: Text("Already have an account")
                        )
                      ]
                )
                )
            );
          }
        ),
      )
    );
  }
}
