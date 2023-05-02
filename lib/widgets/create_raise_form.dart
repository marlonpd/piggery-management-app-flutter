import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CreateRaiseForm extends StatefulWidget {
  const CreateRaiseForm({super.key});

  @override
  State<CreateRaiseForm> createState() => _CreateRaiseFormState();
}

List<String> raiseTypes = <String>['fattener', 'sow', 'boar', 'weaner'];

class _CreateRaiseFormState extends State<CreateRaiseForm> {
  final _nameController = TextEditingController();
  final _headCountController = TextEditingController();

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

  void startCreateRaise(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      controller: _nameController,
                    ),

                        Expanded(
                          child: DropdownButtonHideUnderline(
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
                        )
                  
                    ,
                    Expanded(
                        child: TextField(
                      decoration: const InputDecoration(labelText: 'Head Count'),
                      controller: _headCountController,
                    )),
                    ElevatedButton.icon(
                        onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Create Raise'))
                  ],
                ),
              ),
            );
          });
        });
  }
}
