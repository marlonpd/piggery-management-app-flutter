import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/helpers/theme_helper.dart';
import 'package:pma/providers/user.dart';
import 'package:pma/screens/signin_screen.dart';
import 'package:pma/screens/signup_screen.dart';
import 'package:pma/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/change-password';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final Key _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
  }

  Future<void> changePassword(email, securityCode) async {
    bool isCorrect =  await Provider.of<UserProvider>(context, listen: false).changePassword(
      context: context,
      email: email,
      securityCode: securityCode,
      password: _passwordController.text, 
      confirmPassword: _passwordConfirmController.text,
    );

    if (isCorrect) {
      if (context.mounted) {
          Navigator.of(context)
              .pushNamed(
            SigninScreen.routeName
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic> ;
    String email = args['email']!;
    String securityCode = args['securityCode']!;

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
                        'Enter your new password.',
                        style: TextStyle(color: Colors.grey, fontSize: 12,),
                      ),
                      const SizedBox(height: 15.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
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
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextField(
                                  controller: _passwordConfirmController,
                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration('Password', 'Confirm your password'),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              CustomBtn(
                                    text: 'Change Password',
                                    onTap: () {
                                      //if (_signInFormKey.currentState!.validate()) {
                                      setState(() {
                                        changePassword(email, securityCode);
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
                                  ,
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
