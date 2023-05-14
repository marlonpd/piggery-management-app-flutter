import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/helpers/theme_helper.dart';
import 'package:pma/providers/user.dart';
import 'package:pma/screens/change_password_screen.dart';
import 'package:pma/screens/confirm_security_code_screen.dart';
import 'package:pma/screens/forgot_password_screen.dart';
import 'package:pma/screens/signup_screen.dart';
import 'package:pma/services/auth_service.dart';
import 'package:pma/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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

  Future<void> sendSecurityCode() async {
    bool isSent =  await Provider.of<UserProvider>(context, listen: false).sendSecurityCode(
      context: context,
      email: _emailController.text,
    );

    if (isSent) {
      if (context.mounted) {
          Navigator.of(context)
              .pushNamed(
            ConfirmSecurityCodeScreen.routeName,
            arguments:  _emailController.text,
          );
      }
    }
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
                        'Recover your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 15.0),
                                            const Text(
                        'A security code will be sent to your registered email.',
                        style: TextStyle(color: Colors.grey, fontSize: 12,),
                      ),
                      const SizedBox(height: 15.0),
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
              
                                  child: CustomBtn(
                                    text: 'Send',
                                    onTap: () {
                                      //if (_signInFormKey.currentState!.validate()) {
                                      setState(() {
                                        sendSecurityCode();
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
