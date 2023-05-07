import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pma/helpers/constants.dart';
import 'package:pma/models/accounting.dart';
import 'package:pma/providers/accounting.dart';
import 'package:provider/provider.dart';

class CreateAccountingForm extends StatefulWidget {
  final String raiseId;
  const CreateAccountingForm({super.key, required this.raiseId});

  @override
  State<CreateAccountingForm> createState() => _CreateAccountingFormState();
}

List<String> entryTypes = <String>['income', 'expenses'];

class _CreateAccountingFormState extends State<CreateAccountingForm> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  final _dropdownMenuOptions =
      entryTypes.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList();

  String _entryType = '';

  @override
  void initState() {
    super.initState();
    _entryType = entryTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    String raiseId = widget.raiseId;

    return Column(
      children: <Widget>[
        ElevatedButton(
            onPressed: () {
              startCreateAccounting(context, raiseId);
            },
            child: const Text('Add new'))
      ],
    );
  }

  Future<void> _addNewAccounting(ctx, accounting) async {
    Provider.of<Accountings>(ctx, listen: false).addNewAccounting(context: context, accounting: accounting);
  }

  void startCreateAccounting(BuildContext ctx, String raiseId) {
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
                    const Text('Add new expenses/income'),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Description'),
                      controller: _descriptionController,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Entry Type'),
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
                            value: _entryType,
                            onChanged: (value) {
                              setState(() {
                                _entryType = value as String;
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
                            decoration: const InputDecoration(labelText: 'Amount'),
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly])),
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
                              final Accounting accounting = Accounting(
                                id: '',
                                raiseId: raiseId,
                                description: _descriptionController.text,
                                entryType: _entryType,
                                amount: double.parse(_amountController.text),
                                createdAt: '',
                                updatedAt: '',
                              );
                              _addNewAccounting(context, accounting);
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
