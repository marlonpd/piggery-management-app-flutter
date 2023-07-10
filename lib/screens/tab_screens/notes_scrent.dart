import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/helpers/utils.dart';
import 'package:pma/providers/note.dart';
import 'package:pma/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../models/note.dart';
import '../../models/raise.dart';
import '../../widgets/create_note_form.dart';

class NotesScreen extends StatefulWidget {
  static const String routeName = '/notes';
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {

    Raise raise = ModalRoute.of(context)?.settings.arguments as Raise;
    String raiseId = raise.id;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Notes',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
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
                      child: const Center(child: Text('No notes added.')),
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
      startActionPane: null,

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
            backgroundColor: Color.fromARGB(255, 153, 212, 104),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            flex: 2,
            onPressed: (_) {
              Provider.of<Notes>(context, listen: false).deleteNote(context: context, note: note);
            },
            backgroundColor: Color.fromARGB(255, 228, 111, 111),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
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
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    bool validateTitle = false;
    bool validateDescription = false;

    _titleController.text = note.title;
    _descriptionController.text = note.description;

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
                        'Update Note',
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
                              text: 'Update',
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

                                  note.title = _titleController.text;
                                  note.description = _descriptionController.text;

                                  _updateNote(context, note);
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
