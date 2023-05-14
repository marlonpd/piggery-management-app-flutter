import 'dart:convert';
import 'dart:ffi';

//import 'package:pma/widgets/bottom_bar.dart';
import 'package:pma/helpers/error_handling.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/screens/home_screen.dart';
import 'package:pma/helpers/utils.dart';
import 'package:pma/models/user.dart';
import 'package:pma/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class AuthService1 {
  // sign up user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        token: '',
      );

      log(user.toString());

      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // sign in user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      log('context');
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (context.mounted) {
              Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            }
            log(res.body);
            await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RaiseScreen.routeName,
                (route) => false,
              );
            }
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      log('getuserdata');
      log(token!);
      if (token == null) {
        prefs.setString('x-auth-token', '');
        return;
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/api/auth/tokenIsValid'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'x-auth-token': token!},
      );

      var response = (jsonDecode(tokenRes.body));

      if (response == true) {
        http.Response userRes = await http.post(
          Uri.parse('$uri/api/auth/me'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'x-auth-token': token
          },
        );

        if (context.mounted) {
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(userRes.body);
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void logoutUser(context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('x-auth-token', '');

      if (context.mounted) {
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.clearUser();
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
