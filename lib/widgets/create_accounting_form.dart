import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pma/helpers/constants.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/models/accounting.dart';
import 'package:pma/providers/accounting.dart';
import 'package:pma/widgets/custom_button.dart';
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
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
              onPressed: () {
                startCreateAccounting(context, raiseId);
              },
              child: const Text('Add New')),
        )
      ],
    );
  }

  Future<void> _addNewAccounting(ctx, accounting) async {
    Provider.of<Accountings>(ctx, listen: false).addNewAccounting(context: context, accounting: accounting);
  }

  void startCreateAccounting(BuildContext ctx, String raiseId) {
    bool validateDescription = false;
    bool validateAmount = false;
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

                       Text('Add New Expenses/Income',
                        style: Theme.of(context).textTheme.headlineSmall),
                    
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                          errorText: validateDescription ? 'Value Can\'t Be Empty' : null,
                        ),
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
                        ])
                      ,
                      TextField(
                            decoration: InputDecoration(labelText: 'Amount',  errorText: validateAmount ? 'Value Can\'t Be Empty' : null,),
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]),
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
                                });
                              },
                              isLoading: Provider.of<Accountings>(context, listen: true).isLoading,
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
