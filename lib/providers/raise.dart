import 'dart:convert';

import 'package:pma/helpers/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pma/providers/user.dart';
import 'package:provider/provider.dart';

import '../helpers/error_handling.dart';
import '../helpers/utils.dart';
import '../models/raise.dart';
import 'dart:developer';

class Raises with ChangeNotifier {
  final List<Raise> _items = [];

  List<Raise> get items {
    return [..._items];
  }

  Future<void> fetchRaises(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.get(
        Uri.parse('$uri/api/raise'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      log(res.body.toString());

      _items.clear();

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              _items.add(
                Raise.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    notifyListeners();
  }

  Future<void> addNewRaise({
    required BuildContext context,
    required Raise raise,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      log(raise.toJson());
      log('$uri/api/raise/save');
      log('Bearer ${userProvider.user.token}');
      http.Response res = await http.post(
        Uri.parse('$uri/api/raise/save'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: raise.toJson(),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            log('Succcess');
            _items.add(
              Raise.fromJson(
                jsonEncode(
                  jsonDecode(res.body),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    notifyListeners();
  }

  Future<void> updateRaise({
    required BuildContext context,
    required Raise raise,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/update'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: jsonEncode(raise),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {},
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    notifyListeners();
  }

  Future<void> deleteRaise({
    required BuildContext context,
    required Raise raise,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    log(raise.toJson());
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/raise/delete'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: raise.toJson(),
      );

      log(res.body.toString());

      log(_items.toList().toString());

      _items.removeWhere((item) => item.id == raise.id);

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {

          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    notifyListeners();
  }
}
