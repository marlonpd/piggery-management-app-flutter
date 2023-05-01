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
        ) ;

        log(res.body);

        //var _raises<List<Map<String, dynamic>>> = res.body;

        for (int i = 0; i < jsonDecode(res.body).length; i++) {
            _items.add(
              Raise.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }

        // _items = await Future.wait(res.map((item) async {
        //   return Raise(id: item['_id'], raiseType: item['raise_type'], name: item['name'], headCount: item['head_count']);
        // }).toList());
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    notifyListeners();
  }

  // Future<List<Product>> fetchSearchedProduct({
  //   required BuildContext context,
  //   required String searchQuery,
  // }) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   List<Product> productList = [];
  //   try {
  //     http.Response res = await http.get(
  //       Uri.parse('$uri/api/products/search/$searchQuery'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'x-auth-token': userProvider.user.token,
  //       },
  //     );

  //     httpErrorHandle(
  //       response: res,
  //       context: context,
  //       onSuccess: () {
  //         for (int i = 0; i < jsonDecode(res.body).length; i++) {
  //           productList.add(
  //             Product.fromJson(
  //               jsonEncode(
  //                 jsonDecode(res.body)[i],
  //               ),
  //             ),
  //           );
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  //   return productList;
  // }

} 