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

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
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
      } else {
        log('Raise not properly loaded.');
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          _items.add(
            Raise.fromJson(
              jsonEncode(
                jsonDecode(res.body)[i],
              ),
            ),
          );
        }
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
      _isLoading = true;
      http.Response res = await http.post(
        Uri.parse('$uri/api/raise/save'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: raise.toJson(),
      );

      _items.add(
        Raise.fromJson(
          jsonEncode(
            jsonDecode(res.body),
          ),
        ),
      );
      _isLoading = false;
      notifyListeners();

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            log('Succcess');
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      notifyListeners();
    }
  }

  Future<void> updateRaise({
    required BuildContext context,
    required Raise raise,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final ndx = _items.indexWhere((item) => item.id == raise.id);

      if (ndx >= 0) {
        _items[ndx].name = raise.name;
        _items[ndx].headCount = raise.headCount;
        _items[ndx].raiseType = raise.raiseType;
        _items[ndx].hogPen = raise.hogPen;
        notifyListeners();
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/raise/update'),
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
      _items.removeWhere((item) => item.id == raise.id);
      notifyListeners();

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
}
