import 'package:flutter/material.dart';
import 'package:pma/providers/accounting.dart';
import 'package:provider/provider.dart';

import '../../models/raise.dart';

class DetailScreen extends StatefulWidget {

  static const String routeName = '/detail';
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  
  @override
  Widget build(BuildContext context) {
    Raise raise = ModalRoute.of(context)?.settings.arguments as Raise;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: FutureBuilder(
            future: Provider.of<Accountings>(context, listen: false).fetchAccountingSummary(context, raise.id),
            builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Consumer<Accountings>(
                    child: const Center(child: Text('Note details added.')),
                    builder: (ctxx, events, child) {
                      if (events.accountingSummary == null ) {
                        return child as Widget;
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Details',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Name : ${raise.name}'),
                          Text('Type : ${raise.raiseType}'),
                          Text('Head count : ${raise.headCount.toString()}'),
                          Text('Total expenses : ${events.accountingSummary?.expensesSum}'),
                          Text('Total sales : ${events.accountingSummary?.salesSum}'),
                          Text('Net income : ${events.accountingSummary?.netIncome}'),
                        ],
                      );
                    }),
          )),
        ),
      ),
    );
  }
}
