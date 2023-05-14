import 'dart:convert';

import 'package:pma/models/user.dart';
import 'package:flutter/material.dart';
import 'package:pma/helpers/error_handling.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/screens/home_screen.dart';
import 'package:pma/helpers/utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    token: '',
  );

  User get user => _user;

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void clearUser() {
    _user = User(
      id: '',
      name: '',
      email: '',
      password: '',
      token: '',
    );
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String confirmPassword,
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
      _isLoading = true;

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
      _isLoading = false;
      notifyListeners();
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
      _isLoading = true;

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

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      showSnackBar(context, e.toString());
    }
  }

  // send security in user
  Future<bool> sendSecurityCode({
    required BuildContext context,
    required String email,
  }) async {
    try {
      _isLoading = true;

      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/request-change-password'),
        body: jsonEncode({
          'email': email,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {

          },
        );
      }

      var isSent = (jsonDecode(res.body)); 

      _isLoading = false;
      notifyListeners();

      return isSent['is_sent'] as bool;
    } catch (e) {
      _isLoading = false;
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> confirmSecurityCode({
    required BuildContext context,
    required String email,
    required String securityCode,
  }) async {
    try {
      _isLoading = true;

      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/confirm-security-code'),
        body: jsonEncode({
          'email': email,
          'security_code': securityCode,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {

          },
        );
      }

      var isSent = (jsonDecode(res.body)); 

      _isLoading = false;
      notifyListeners();

      return isSent['is_correct'] as bool;
    } catch (e) {
      _isLoading = false;
      showSnackBar(context, e.toString());
      return false;
    }
  }


  Future<bool> changePassword({
    required BuildContext context,
    required String email,
    required String securityCode,
    required String password,
    required String confirmPassword
  }) async {
    try {
      _isLoading = true;

      log(jsonEncode({
          'email': email,
          'security_code': securityCode,
          'password': password, 
          'password_confirm': confirmPassword
        }));

      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/request-update-password'),
        body: jsonEncode({
          'email': email,
          'security_code': securityCode,
          'password': password, 
          'password_confirm': confirmPassword
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var resp = (jsonDecode(res.body)); 

      bool isSuccess = resp['is_success'];
      String msg = resp['msg'];

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            showSnackBar(context, msg);
          },
        );
      }

      _isLoading = false;
      notifyListeners();

      return isSuccess;
    } catch (e) {
      _isLoading = false;
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> updatePassword({
    required BuildContext context,
    required String oldPassword,
    required String password,
    required String confirmPassword
  }) async {
    try {
      _isLoading = true;

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      log(jsonEncode({
          'old_password': oldPassword, 
          'password': password, 
          'password_confirm': confirmPassword
        }));

      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/update-password'),
        body: jsonEncode({
          'old_password': oldPassword, 
          'password': password, 
          'password_confirm': confirmPassword
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );
      log('await');
      log(res.body.toString());

      var resp = (jsonDecode(res.body)); 

      bool isSuccess = resp['is_success'];
      String msg = resp['msg'];

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            showSnackBar(context, msg);
          },
        );
      }

      _isLoading = false;
      notifyListeners();

      return isSuccess;
    } catch (e) {
      _isLoading = false;
      showSnackBar(context, e.toString());
      return false;
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

      log('getuser');

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
