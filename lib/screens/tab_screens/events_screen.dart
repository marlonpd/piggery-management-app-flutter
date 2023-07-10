import 'dart:developer';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/helpers/utils.dart';
import 'package:pma/models/event.dart';
import 'package:pma/models/raise.dart';
import 'package:pma/providers/event.dart';
import 'package:pma/widgets/create_event_form.dart';
import 'package:pma/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatefulWidget {

  static const String routeName = '/events';
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
          child: Text(
            'Events',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          height: 3,
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
                      child: const Center(child: Text('No events added.')),
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
      startActionPane: null,

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
            backgroundColor: const Color.fromARGB(255, 153, 212, 104),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) {
              Provider.of<Events>(context, listen: false).deleteEvent(context: context, event: event);
            },
            backgroundColor: const Color.fromARGB(255, 228, 111, 111),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: GestureDetector(
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
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
    bool validateTitle = false;
    bool validateEventDate = false;
    final titleController = TextEditingController();
    DateTime selectedDate = DateTime.parse(event.eventDate);
    titleController.text = event.title;

    showModalBottomSheet(
        backgroundColor: GlobalVariables.backgroundColor,
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Edit Event',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                          errorText: validateTitle ? 'Value Can\'t Be Empty' : null,
                        ),
                        controller: titleController,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DateTimeFormField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.event_note),
                          labelText: 'Event Date',
                          errorText: validateEventDate ? 'Value Can\'t Be Empty' : null,
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                        //selectedDate: selectedDate,
                        onDateSelected: (DateTime value) {
                          selectedDate = value;
                          print(value.toIso8601String());
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                        child: Row(
                          children: [
                            CustomBtn(
                              text: 'Cancel',
                              onTap: () {
                                Navigator.pop(context);
                              },
                              isLoading: false,
                            ),
                            const Spacer(),
                            CustomBtn(
                              text: 'Update',
                              onTap: () async {
                                setState(() {
                                  if (titleController.text.isEmpty) {
                                    validateTitle = true;
                                    return;
                                  }

                                  if (selectedDate.toString().isEmpty) {
                                    validateEventDate = true;
                                    return;
                                  }

                                  event.title = titleController.text;
                                  event.eventDate = selectedDate.toString();
                                  _updateEvent(context, event);
                                  Navigator.pop(context);
                                });
                              },
                              isLoading: Provider.of<Events>(context, listen: true).isLoading,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
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
