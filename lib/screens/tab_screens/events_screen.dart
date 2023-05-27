import 'dart:developer';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pma/helpers/utils.dart';
import 'package:pma/models/event.dart';
import 'package:pma/models/raise.dart';
import 'package:pma/providers/event.dart';
import 'package:pma/widgets/create_event_form.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatefulWidget {
  final Raise raise;
  const EventsScreen({super.key, required this.raise});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    String raiseId = widget.raise.id;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Text('Events'),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              log('Refresh');
              //await Provider.of<Notes>(context, listen: false).fetchNotes(context, raiseId);
            },
            child: SingleChildScrollView(
                child: FutureBuilder(
              future: Provider.of<Events>(context, listen: false).fetchEvents(context, raiseId),
              builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Consumer<Events>(
                      child: const Center(child: Text('No raised hog added')),
                      builder: (ctxx, events, child) {
                        if (events.items.isEmpty) {
                          return child as Widget;
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: events.items.length,
                          itemBuilder: (ctx, i) => _eventItem(ctx, i, events.items[i]),
                        );
                      }),
            )),
          ),
        ),
        Center(child: (CreateEventForm(raiseId: raiseId)))
      ],
    );
  }

  Widget _eventItem(BuildContext context, int index, Event event) {
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
              Provider.of<Events>(context, listen: false).deleteEvent(context: context, event: event);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
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
            onPressed: (_) {
              _startEditEvent(context, event);
            },
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: GestureDetector(
          child: ListTile(
            title: Text(
              event.title,
            ),
            subtitle: Text(toFormattedDate(event.eventDate)),
            trailing: const Text(''),
          ),
          onDoubleTap: () {
            setState(() {
              // indexToEdit = index;
              // _editNameController.text = budget.name;
            });
          },
          onTap: () {
            //setState(() {});
          }),
    );
  }

  void _startEditEvent(BuildContext ctx, Event event) {
    final titleController = TextEditingController();
    DateTime selectedDate = DateTime.parse(event.eventDate);
    titleController.text = event.title;

    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return GestureDetector(
              onTap: () {},
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20, right: 20, left: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text('Add new note.'),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      controller: titleController,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: DateTimeField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.event_note),
                            labelText: 'Event Date',
                          ),
                          mode: DateTimeFieldPickerMode.date,
                          // autovalidateMode: AutovalidateMode.always,
                          // validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                          selectedDate: selectedDate,
                          onDateSelected: (DateTime value) {
                            setState(() {
                              selectedDate = value;
                            });
                            print(selectedDate.toIso8601String());
                          },
                        )),
                    Row(
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel),
                            label: const Text('Cancel')),
                        const Spacer(),
                        ElevatedButton.icon(
                            onPressed: () {
                              setState(
                                () {
                                  event.title = titleController.text;
                                  event.eventDate = selectedDate.toString();
                                  _updateEvent(context, event);
                                  Navigator.pop(context);
                                },
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Update Event'))
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> _updateEvent(ctx, Event event) async {
    Provider.of<Events>(ctx, listen: false).updateEvent(context: context, event: event);
  }
}
