

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../helpers/global_variables.dart';

class HogDetailScreen extends StatefulWidget {
  const HogDetailScreen({super.key});

  static const routeName = '/hog-detail';

  @override
  State<HogDetailScreen> createState() => _HogDetailScreenState();
}

class _HogDetailScreenState extends State<HogDetailScreen> {

  var raiseId = '';

  @override
  Widget build(BuildContext context) {
    raiseId = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      appBar: AppBar(
        title: const Text('Raised Hog'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios, // add custom icons also
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
            
              },
              icon: const Icon(Icons.add))
        ],
        ), 
        body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(raiseId),
          ),
        ],
      ),
      );
  }
}