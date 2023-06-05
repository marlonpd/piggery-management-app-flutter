import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/models/event.dart';
import 'package:pma/providers/event.dart';
import 'package:pma/widgets/custom_button.dart';
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
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
              onPressed: () {
                startCreateEvent(context, raiseId);
              },
              child: const Text('Add New')),
        )
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
    bool validateTitle = false;
    bool validateEventDate = false;
    _titleController.text = '';

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
                        'Add Event',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                          errorText: validateTitle ? 'Value Can\'t Be Empty' : null,
                        ),
                        controller: _titleController,
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
                              text: 'Create',
                              onTap: () async {
                                setState(() {
                                  if (_titleController.text.isEmpty) {
                                    validateTitle = true;
                                    return;
                                  }

                                  if (selectedDate.toString().isEmpty) {
                                    validateEventDate = true;
                                    return;
                                  }

                                  _addNewEvent(context, raiseId, selectedDate.toString());
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
}
