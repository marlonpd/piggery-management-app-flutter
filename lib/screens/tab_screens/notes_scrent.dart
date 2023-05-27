import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pma/helpers/utils.dart';
import 'package:pma/providers/note.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../models/note.dart';
import '../../models/raise.dart';
import '../../widgets/create_note_form.dart';

class NotesScreen extends StatefulWidget {
  final Raise raise;
  const NotesScreen({super.key, required this.raise});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    String raiseId = widget.raise.id;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Text('Notes'),
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
              future: Provider.of<Notes>(context, listen: false).fetchNotes(context, raiseId),
              builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Consumer<Notes>(
                      child: const Center(child: Text('No raised hog added')),
                      builder: (ctxx, notes, child) {
                        if (notes.items.isEmpty) {
                          return child as Widget;
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: notes.items.length,
                          itemBuilder: (ctx, i) => _raiseItem(ctx, i, notes.items[i]),
                        );
                      }),
            )),
          ),
        ),
        Center(child: (CreateNoteForm(raiseId: raiseId)))
      ],
    );
  }

  Widget _raiseItem(BuildContext context, int index, Note note) {
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
              Provider.of<Notes>(context, listen: false).deleteNote(context: context, note: note);
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
              // _startEditRaise(context, raise);
              _startEditNote(context, note);
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
              note.title,
            ),
            subtitle: Text(note.description.length > 10 ? '${note.description.substring(0, 10)}...' : note.description),
            trailing: Text(toFormattedDate(note.createdAt)),
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

  Future<void> _updateNote(ctx, Note note) async {
    Provider.of<Notes>(ctx, listen: false).updateNote(context: context, note: note);
  }

  void _startEditNote(BuildContext ctx, Note note) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    titleController.text = note.title;
    descriptionController.text = note.description;

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
                    Expanded(
                        child: TextField(
                      maxLines: 10,
                      decoration: const InputDecoration(labelText: 'Description'),
                      controller: descriptionController,
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
                                  note.title = titleController.text;
                                  note.description = descriptionController.text;
                                  _updateNote(context, note);
                                  Navigator.pop(context);
                                },
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Update Note'))
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
