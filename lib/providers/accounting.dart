import 'dart:async';
import 'dart:convert';

import 'package:pma/helpers/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pma/models/accounting_summary.dart';
//import 'package:pma/models/accounting_summary.dart';
import 'package:pma/providers/user.dart';
import 'package:provider/provider.dart';

import '../helpers/error_handling.dart';
import '../helpers/utils.dart';
import 'dart:developer';

import '../models/accounting.dart';

class Accountings with ChangeNotifier {
  final List<Accounting> _items = [];

  List<Accounting> get items {
    return [..._items];
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  AccountingSummary? _accountingSummary;

  AccountingSummary? get accountingSummary {
    return _accountingSummary;
  }

  Future<void> fetchAccountings(BuildContext context, String raiseId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      log('$uri/api/accounting?raise_id=$raiseId');
      _isLoading = true;
      http.Response res = await http.get(
        Uri.parse('$uri/api/accounting?raise_id=$raiseId'),
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
                Accounting.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
            _isLoading = false;
          },
        );
      }
    } catch (e) {
      _isLoading = false;
      showSnackBar(context, e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAccountingSummary(BuildContext context, String raiseId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      log('$uri/api/accounting/summary?raise_id=$raiseId');
      http.Response res = await http.get(
        Uri.parse('$uri/api/accounting/summary?raise_id=$raiseId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            if (res.statusCode == 200) {
              final accountngSummaryJson = jsonDecode(res.body);
              _accountingSummary = AccountingSummary(
                expensesSum: double.parse(accountngSummaryJson['expenses_sum'].toString()),
                salesSum: double.parse(accountngSummaryJson['sales_sum'].toString()),
                netIncome: double.parse(accountngSummaryJson['net_income'].toString()),
              );
            }
          },
        );
      }
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    notifyListeners();
  }

  Future<void> addNewAccounting({
    required BuildContext context,
    required Accounting accounting,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      log(accounting.toJson());
      log('$uri/api/accounting/save');
      log('Bearer ${userProvider.user.token}');
      _isLoading = true;
      http.Response res = await http.post(
        Uri.parse('$uri/api/accounting/save'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: accounting.toJson(),
      );

      log(res.body.toString());

      _items.add(
        Accounting.fromJson(
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
    }
  }

  Future<void> updateAccounting({
    required BuildContext context,
    required Accounting accounting,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final ndx = _items.indexWhere((item) => item.id == accounting.id);

      if (ndx >= 0) {
        _items[ndx].description = accounting.description;
        _items[ndx].entryType = accounting.entryType;
        _items[ndx].amount = accounting.amount;
        _items[ndx].createdAt = accounting.createdAt;
        _items[ndx].updatedAt = accounting.updatedAt;
        notifyListeners();
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/accounting/update'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: accounting.toJson(),
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
    //notifyListeners();
  }

  Future<void> deleteAccounting({
    required BuildContext context,
    required Accounting accounting,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    log(accounting.toJson());
    try {
      _items.removeWhere((item) => item.id == accounting.id);
      notifyListeners();

      http.Response res = await http.post(
        Uri.parse('$uri/api/accounting/delete'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: accounting.toJson(),
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
