import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
        ElevatedButton(
            onPressed: () {
              startCreateNote(context, raiseId);
            },
            child: const Text('Add new'))
      ],
    );
  }

  Future<void> _addNewRaise(ctx, raiseId) async {
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
                    Expanded(
                        child: TextField(
                      maxLines: 10,
                      decoration: const InputDecoration(labelText: 'Description'),
                      controller: _descriptionController,
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
                              _addNewRaise(context, raiseId);
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
