import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pma/screens/tab_screens/accounting_screen.dart';
import 'package:pma/screens/tab_screens/detail_screen.dart';
import 'package:pma/screens/tab_screens/events_screen.dart';
import 'package:pma/screens/tab_screens/notes_scrent.dart';

import '../helpers/global_variables.dart';
import '../models/raise.dart';

class HogDetailScreen extends StatefulWidget {
  const HogDetailScreen({super.key});

  static const routeName = '/hog-detail';

  @override
  State<HogDetailScreen> createState() => _HogDetailScreenState();
}

class _HogDetailScreenState extends State<HogDetailScreen> with TickerProviderStateMixin {
  late TabController _controller;
  int _selectedIndex = 0;

  var raiseId = '';

  @override
  void initState() {
    super.initState();
    _controller = TabController(initialIndex: 0, length: 4, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      log("Selected Index: " + _controller.index.toString());
    });
    log('init state');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var raise = ModalRoute.of(context)?.settings.arguments as Raise;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _controller,
            tabs: const [
              Tab(icon: Icon(Icons.toc)),
              Tab(icon: Icon(Icons.description)),
              Tab(icon: Icon(Icons.calendar_month)),
              Tab(icon: Icon(Icons.calculate)),
            ],
          ),
          title: const Text('Hogs'),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            DetailScreen(raise: raise),
            NotesScreen(raise: raise),
            EventsScreen(raise: raise),
            AccountingScreen(raise: raise),
          ],
        ),
      ),
    );
  }
}
