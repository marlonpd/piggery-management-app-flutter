import 'package:flutter/material.dart';

import '../../models/raise.dart';

class DetailScreen extends StatefulWidget {
  final Raise raise;

  const DetailScreen({super.key, required this.raise});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    Raise raise = widget.raise;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text('Details'),
          ),
          SizedBox(
            height: 10,
          ),
          Text('Name : ${raise.name}'),
          Text('Type : ${raise.raiseType}'),
          Text('Head count : ${raise.headCount.toString()}'),
        ],
      ),
    );
  }
}
