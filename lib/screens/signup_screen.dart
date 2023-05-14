import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/helpers/theme_helper.dart';
import 'package:pma/providers/user.dart';
import 'package:pma/screens/forgot_password_screen.dart';
import 'package:pma/screens/signin_screen.dart';
import 'package:pma/screens/signup_screen.dart';
import 'package:pma/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  double _headerHeight = 250;
  final Key _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void signUpUser() {
    Provider.of<UserProvider>(context, listen: false).signUpUser(
      context: context,
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _passwordController.text,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            SafeArea(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                       const FittedBox(
                          fit: BoxFit.fitWidth, 
                          child: Text(
                            'HogMaster',
                            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                          )
                      ),
                      const Text(
                        'Create account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextField(
                                  controller: _nameController,
                                  decoration: ThemeHelper().textInputDecoration('Name', 'Enter your name'),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: ThemeHelper().textInputDecoration('Email', 'Enter your email'),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration:
                                      ThemeHelper().textInputDecoration('Confirm Password', 'Confirm your password'),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                               CustomBtn(
                                    text: 'Sign up',
                                    onTap: () {
                                      //if (_signInFormKey.currentState!.validate()) {
                                      setState(() {
                                        signUpUser();
                                      });
                                      //}
                                    },
                                    isLoading: Provider.of<UserProvider>(context, listen: true).isLoading,
                                ),
                                // child: ElevatedButton(
                                //   style: ThemeHelper().buttonStyle(),
                                //   child: Padding(
                                //     padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                //     child: Text(
                                //       'Sign Up'.toUpperCase(),
                                //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                //     ),
                                //   ),
                                //   onPressed: () {
                                //     //After successful login we will redirect to profile page. Let's create profile page now
                                //     Navigator.pushReplacement(
                                //         context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                                //   },
                                // ),
                              
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Already have an account? "),
                                  TextSpan(
                                    text: 'Sign in',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => const SigninScreen()));
                                      },
                                    style: TextStyle(fontWeight: FontWeight.bold, color: GlobalVariables.linkTextColor),
                                  ),
                                ])),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
