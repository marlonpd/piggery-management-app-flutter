import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/helpers/theme_helper.dart';
import 'package:pma/providers/user.dart';
import 'package:pma/screens/forgot_password_screen.dart';
import 'package:pma/screens/signup_screen.dart';
import 'package:pma/services/auth_service.dart';
import 'package:pma/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  static const String routeName = '/signin';

  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final Key _formKey = GlobalKey<FormState>();
  //final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signInUser() {
    Provider.of<UserProvider>(context, listen: false).signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: SizedBox.fromSize(
                child: FittedBox(
                  child: Icon(
                    Icons.savings,
                    size: MediaQuery.of(context).size.width * 0.45,
                  ),
                ),
              ),
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
                      )
                      ,
                      const Text(
                        'Signin into your account',
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
                                  controller: _emailController,
                                  decoration: ThemeHelper().textInputDecoration('Email', 'Enter your email'),
                                ),
                              ),
                              const SizedBox(height: 30.0),
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
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                                    );
                                  },
                                  child: Text(
                                    "Forgot your password?",
                                    style: TextStyle(color: GlobalVariables.linkTextColor),
                                  ),
                                ),
                              ),
                              Container(
              
                                  child: CustomBtn(
                                    text: 'Sign In',
                                    onTap: () {
                                      //if (_signInFormKey.currentState!.validate()) {
                                      setState(() {
                                        signInUser();
                                      });
                                      //}
                                    },
                                    isLoading: Provider.of<UserProvider>(context, listen: true).isLoading,
                                  )
                                  // child: ElevatedButton(
                                  //   style: ThemeHelper().buttonStyle(),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  //     child: Text(
                                  //       'Sign In'.toUpperCase(),
                                  //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  //     ),
                                  //   ),
                                  //   onPressed: () {
                                  //     //After successful login we will redirect to profile page. Let's create profile page now
                                  //     Navigator.pushReplacement(
                                  //         context, MaterialPageRoute(builder: (context) => SignupScreen()));
                                  //   },
                                  // ),
                                  ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Don\'t have an account? "),
                                  TextSpan(
                                    text: 'Create',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => SignupScreen()));
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
