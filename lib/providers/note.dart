import 'dart:convert';

import 'package:pma/helpers/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pma/providers/user.dart';
import 'package:provider/provider.dart';

import '../helpers/error_handling.dart';
import '../helpers/utils.dart';
import '../models/note.dart';
import 'dart:developer';

class Notes with ChangeNotifier {
  final List<Note> _items = [];

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  List<Note> get items {
    return [..._items];
  }

  Future<void> fetchNotes(BuildContext context, String raiseId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      log('$uri/api/note?raise_id=$raiseId');
      http.Response res = await http.get(
        Uri.parse('$uri/api/note?raise_id=$raiseId'),
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
                Note.fromJson(
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

  Future<void> addNewNote({
    required BuildContext context,
    required Note note,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      _isLoading = true;
      http.Response res = await http.post(
        Uri.parse('$uri/api/note/save'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: note.toJson(),
      );

      log(res.body.toString());

      _items.add(
        Note.fromJson(
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

  Future<void> updateNote({
    required BuildContext context,
    required Note note,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      _isLoading = true;
      final ndx = _items.indexWhere((item) => item.id == note.id);

      log(note.toJson());

      if (ndx >= 0) {
        _items[ndx].title = note.title;
        _items[ndx].description = note.description;
        _items[ndx].createdAt = note.createdAt;
        _items[ndx].updatedAt = note.updatedAt;
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/note/update'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: note.toJson(),
      );

      _isLoading = false;
      notifyListeners();

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
  }

  Future<void> deleteNote({
    required BuildContext context,
    required Note note,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    log(note.toJson());
    try {
      _items.removeWhere((item) => item.id == note.id);
      notifyListeners();

      http.Response res = await http.post(
        Uri.parse('$uri/api/note/delete'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user.token}',
        },
        body: note.toJson(),
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
}
