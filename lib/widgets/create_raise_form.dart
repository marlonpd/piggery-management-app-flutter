import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pma/models/raise.dart';
import 'package:pma/providers/raise.dart';
import 'package:provider/provider.dart';

class CreateRaiseForm extends StatefulWidget {
  const CreateRaiseForm({super.key});

  @override
  State<CreateRaiseForm> createState() => _CreateRaiseFormState();
}

List<String> raiseTypes = <String>['fattener', 'sow', 'boar', 'weaner'];

class _CreateRaiseFormState extends State<CreateRaiseForm> {
  final _nameController = TextEditingController();
  final _headCountController = TextEditingController();
  final _pigPenController = TextEditingController();

  bool isCreateRaise = false;
  String _raiseType = '';

  final _dropdownMenuOptions =
      raiseTypes.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList();

  @override
  void initState() {
    super.initState();
    _raiseType = raiseTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
            onPressed: () {
              startCreateRaise(context);
            },
            child: const Text('Add new'))
      ],
    );
  }

  Future<void> _addNewRaise(ctx) async {
    final Raise raise = Raise(
        id: '', raiseType: _raiseType, headCount: int.parse(_headCountController.text), name: _nameController.text);
    Provider.of<Raises>(ctx, listen: false).addNewRaise(context: context, raise: raise);
  }

  void startCreateRaise(BuildContext ctx) {
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
                    const Text('Add new livestock to raise'),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      controller: _nameController,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('What type are you going to raise?'),
                          DropdownButtonHideUnderline(
                              child: DropdownButton2(
                            hint: Text(
                              'Select Item',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: _dropdownMenuOptions,
                            value: _raiseType,
                            onChanged: (value) {
                              setState(() {
                                _raiseType = value as String;
                              });
                            },
                            buttonStyleData: const ButtonStyleData(
                              height: 40,
                              width: 140,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          )),
                        ]),
                    Expanded(
                        child: TextField(
                      decoration: const InputDecoration(labelText: 'Head Count'),
                      controller: _headCountController,
                    )),
                    Expanded(
                        child: TextField(
                      decoration: const InputDecoration(labelText: 'Pig Pen'),
                      controller: _pigPenController,
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
                              _addNewRaise(context);
                              Navigator.pop(context);

                              //},);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Create Raise'))
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
