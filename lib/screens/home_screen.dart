import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pma/providers/raise.dart';
import 'package:provider/provider.dart';

import '../helpers/global_variables.dart';
import '../models/raise.dart';
import '../widgets/create_raise_form.dart';

class RaiseScreen extends StatefulWidget {
  static const String routeName = '/raise';

  const RaiseScreen({super.key});

  @override
  State<RaiseScreen> createState() => _RaiseScreenState();
}

class _RaiseScreenState extends State<RaiseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      appBar: AppBar(
        title: const Text('Raised Hog'),
        leading: GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.menu, // add custom icons also
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                startCreateNewRaise(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: FutureBuilder(
              future: Provider.of<Raises>(context, listen: false).fetchRaises(context),
              builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<Raises>(
                      child: const Center(child: Text('No raised hog added')),
                      builder: (ctxx, raises, child) {
                        if (raises.items.isEmpty) {
                          return child as Widget;
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: raises.items.length,
                          itemBuilder: (ctx, i) => _raiseItem(ctx, i, raises.items[i]),
                        );
                      }),
            )),
          ),
          const Center(child: (CreateRaiseForm()))
        ],
      ),
    );
  }

  Widget _raiseItem(BuildContext context, int index, Raise raise) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () {}),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (_) {
              Provider.of<Raises>(context, listen: false).deleteRaise(context: context , raise:raise);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (_) {},
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: const Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'Save',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: ListTile(title: Text('${raise.name} - head count:  ${raise.headCount}')),
    );
  }

  void startCreateNewRaise(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: CreateRaiseForm(),
              ));
        });
  }
}
