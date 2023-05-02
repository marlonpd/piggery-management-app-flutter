import 'dart:convert';

import 'package:pma/helpers/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pma/providers/user.dart';
import 'package:provider/provider.dart';

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

      for (int i = 0; i < jsonDecode(res.body).length; i++) {
        _items.add(
          Raise.fromJson(
            jsonEncode(
              jsonDecode(res.body)[i],
            ),
          ),
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    notifyListeners();
  }
}
