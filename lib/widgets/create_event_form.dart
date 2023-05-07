import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pma/models/event.dart';
import 'package:pma/providers/event.dart';
import 'package:provider/provider.dart';

class CreateEventForm extends StatefulWidget {
  final String raiseId;
  const CreateEventForm({
    Key? key,
    required this.raiseId,
  }) : super(key: key);

  @override
  State<CreateEventForm> createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String raiseId = widget.raiseId;

    return Column(
      children: <Widget>[
        ElevatedButton(
            onPressed: () {
              startCreateEvent(context, raiseId);
            },
            child: const Text('Add new'))
      ],
    );
  }

  Future<void> _addNewEvent(ctx, raiseId, eventDate) async {
    final Event event = Event(
      id: '',
      title: _titleController.text,
      eventDate: eventDate,
      raiseId: raiseId,
      createdAt: '',
      updatedAt: '',
    );
    Provider.of<Events>(ctx, listen: false).addNewEvent(context: context, event: event);
  }

  void startCreateEvent(BuildContext ctx, String raiseId) {
    DateTime? selectedDate;
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
                      controller: _titleController,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: DateTimeFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.event_note),
                            labelText: 'Event Date',
                          ),
                          mode: DateTimeFieldPickerMode.date,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                          //selectedDate: selectedDate,
                          onDateSelected: (DateTime value) {
                            selectedDate = value;
                            print(value.toIso8601String());
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
                              //setState(() {
                              _addNewEvent(context, raiseId, selectedDate.toString());
                              Navigator.pop(context);

                              //},);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Note'))
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
