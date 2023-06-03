import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import 'package:pma/models/note.dart';
import 'package:pma/providers/note.dart';

// class DetailScreen extends StatefulWidget {
//   final Raise raise;

//   const DetailScreen({super.key, required this.raise});

//   @override
//   State<DetailScreen> createState() => _DetailScreenState();
// }

class CreateNoteForm extends StatefulWidget {
  final String raiseId;

  const CreateNoteForm({
    Key? key,
    required this.raiseId,
  }) : super(key: key);

  @override
  State<CreateNoteForm> createState() => _CreateNoteFormState();
}

class _CreateNoteFormState extends State<CreateNoteForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String raiseId = widget.raiseId;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
              onPressed: () {
                startCreateNote(context, raiseId);
              },
              child: const Text('Add new')),
        )
      ],
    );
  }

  Future<void> _addNewNote(ctx, raiseId) async {
    final Note note = Note(
      id: '',
      title: _titleController.text,
      description: _descriptionController.text,
      raiseId: raiseId,
      createdAt: '',
      updatedAt: '',
    );
    Provider.of<Notes>(ctx, listen: false).addNewNote(context: context, note: note);
  }

  void startCreateNote(BuildContext ctx, String raiseId) {
    bool validateTitle = false;
    bool validateDescription = false;
    _titleController.text = '';
    _descriptionController.text = '';

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
                        'Add Note',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                          errorText: validateTitle ? 'Value Can\'t Be Empty' : null,
                        ),
                        controller: _titleController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                          errorText: validateDescription ? 'Value Can\'t Be Empty' : null,
                        ),
                        controller: _descriptionController,
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

                                  if (_descriptionController.text.isEmpty) {
                                    validateDescription = true;
                                    return;
                                  }

                                  _addNewNote(context, raiseId);
                                  Navigator.pop(context);
                                });
                              },
                              isLoading: Provider.of<Notes>(context, listen: true).isLoading,
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
