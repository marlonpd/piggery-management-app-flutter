import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/helpers/theme_helper.dart';
import 'package:pma/models/raise.dart';
import 'package:pma/providers/raise.dart';
import 'package:pma/widgets/custom_button.dart';
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
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CustomBtn(
            text: 'Add New',
            onTap: () {
              setState(() {
                startCreateRaise(context);
              });
            },
            isLoading: false,
          ),
        )
      ],
    );
  }

  Future<void> _addNewRaise(ctx) async {
    final Raise raise = Raise(
        id: '',
        raiseType: _raiseType,
        headCount: int.parse(_headCountController.text),
        name: _nameController.text,
        hogPen: _pigPenController.text);
    await Provider.of<Raises>(ctx, listen: false).addNewRaise(context: context, raise: raise);
    _headCountController.text = '';
    _nameController.text = '';
    _headCountController.text = '';
  }

  //  final _nameController = TextEditingController();
  // final _headCountController = TextEditingController();
  // final _pigPenController = TextEditingController();


  void startCreateRaise(BuildContext ctx) {
    bool _validateName = false;
    bool _validatePenName = false;
    bool _validateHeadCount= false;
    _nameController.text = '';
    _headCountController.text = '';
    _pigPenController.text = '';

    showModalBottomSheet(
        backgroundColor: GlobalVariables.backgroundColor,
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(

              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Add new livestock to raise', 
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        TextField(
                            decoration: InputDecoration(labelText: 'Name', 
                            errorText: _validateName ? 'Value Can\'t Be Empty' : null,
                          ),
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
                        if (_raiseType == 'fattener')
                          Container(
                              child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Head Count',  errorText: _validateHeadCount ? 'Value Can\'t Be Empty' : null,),
                            controller: _headCountController,
                          )),
                        Container(
                            child: TextField(
                          decoration: InputDecoration(labelText: 'Pen Name', 
                             errorText: _validatePenName ? 'Value Can\'t Be Empty' : null,
                          ),
                          controller: _pigPenController,
                        )),
                        Padding(
                          padding: const EdgeInsets.only(top:10.0, bottom: 20),
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
                                    if (_nameController.text.isEmpty) {
                                        _validateName = true;
                                        return;
                                    }

                                    if (_raiseType == 'fattener' && _headCountController.text.isEmpty) {
                                      _validateHeadCount = true;
                                      return;
                                    }

                                    if (_pigPenController.text.isEmpty) {
                                        _validatePenName = true;
                                        return;
                                    }

                                    if (!_nameController.text.isEmpty && !_pigPenController.text.isEmpty) { 
                                      _addNewRaise(context);
                                      Navigator.pop(context);
                                    }
                                    
                                  });
                                },
                                isLoading: Provider.of<Raises>(context, listen: true).isLoading,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }
}
