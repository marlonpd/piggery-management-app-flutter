import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/helpers/theme_helper.dart';
import 'package:pma/providers/user.dart';
import 'package:pma/screens/home_screen.dart';
import 'package:pma/screens/signin_screen.dart';
import 'package:pma/screens/signup_screen.dart';
import 'package:pma/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class UpdatePasswordScreen extends StatefulWidget {
  static const String routeName = '/auth-update-password';
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final Key _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
  }

  Future<void> updatePassword() async {
    bool isCorrect = await Provider.of<UserProvider>(context, listen: false).updatePassword(
      context: context,
      oldPassword: _oldPasswordController.text,
      password: _passwordController.text,
      confirmPassword: _passwordConfirmController.text,
    );

    if (isCorrect) {
      if (context.mounted) {
        _oldPasswordController.text = '';
        _passwordController.text = '';
        _passwordConfirmController.text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 20.0,
            onPressed: () {
              Navigator.of(context).pushNamed(RaiseScreen.routeName);
            },
          ),
          centerTitle: true,
          title: const Text('')),
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
                      const Text(
                        'Change Password',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 15.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextField(
                                  controller: _oldPasswordController,
                                  obscureText: true,
                                  decoration:
                                      ThemeHelper().textInputDecoration('Old Password', 'Enter your old password'),
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
                                  controller: _passwordConfirmController,
                                  obscureText: true,
                                  decoration:
                                      ThemeHelper().textInputDecoration('Confirm Password', 'Confirm your password'),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              CustomBtn(
                                text: 'Change Password',
                                onTap: () {
                                  //if (_signInFormKey.currentState!.validate()) {
                                  setState(() {
                                    updatePassword();
                                  });
                                  //}
                                },
                                isLoading: Provider.of<UserProvider>(context, listen: true).isLoading,
                              )
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
