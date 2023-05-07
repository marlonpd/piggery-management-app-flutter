import 'dart:convert';

import 'package:pma/helpers/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pma/providers/user.dart';
import 'package:provider/provider.dart';

import '../helpers/error_handling.dart';
import '../helpers/utils.dart';
import 'dart:developer';

import '../models/event.dart';

class Events with ChangeNotifier {
  final List<Event> _items = [];

  List<Event> get items {
    return [..._items];
  }

  Future<void> fetchEvents(BuildContext context, String raiseId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      log('$uri/api/event?raise_id=$raiseId');
      http.Response res = await http.get(
        Uri.parse('$uri/api/event?raise_id=$raiseId'),
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
                Event.fromJson(
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

  Future<void> addNewEvent({
    required BuildContext context,
    required Event event,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      log(event.toJson());
      log('$uri/api/event/save');
      log('Bearer ${userProvider.user.token}');
      http.Response res = await http.post(
        Uri.parse('$uri/api/event/save'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: event.toJson(),
      );

      log(res.body.toString());

      _items.add(
        Event.fromJson(
          jsonEncode(
            jsonDecode(res.body),
          ),
        ),
      );

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
    notifyListeners();
  }

  Future<void> updateEvent({
    required BuildContext context,
    required Event event,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final ndx = _items.indexWhere((item) => item.id == event.id);

      if (ndx >= 0) {
        _items[ndx].title = event.title;
        _items[ndx].eventDate = event.eventDate;
        _items[ndx].createdAt = event.createdAt;
        _items[ndx].updatedAt = event.updatedAt;
        notifyListeners();
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/event/update'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: event.toJson(),
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

  Future<void> deleteEvent({
    required BuildContext context,
    required Event event,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    log(event.toJson());
    try {
      _items.removeWhere((item) => item.id == event.id);
      notifyListeners();

      http.Response res = await http.post(
        Uri.parse('$uri/api/event/delete'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: event.toJson(),
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
