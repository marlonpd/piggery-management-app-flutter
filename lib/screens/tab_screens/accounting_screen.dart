import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pma/helpers/constants.dart';
import 'package:pma/models/raise.dart';
import 'package:pma/models/accounting.dart';
import 'package:pma/providers/accounting.dart';
import 'package:pma/widgets/create_accounting_form.dart';
import 'package:provider/provider.dart';

class AccountingScreen extends StatefulWidget {
  final Raise raise;
  const AccountingScreen({super.key, required this.raise});

  @override
  State<AccountingScreen> createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {
  @override
  Widget build(BuildContext context) {
    String raiseId = widget.raise.id;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Accounting',
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
              future: Provider.of<Accountings>(context, listen: false).fetchAccountings(context, raiseId),
              builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Consumer<Accountings>(
                      child: const Center(child: Text('No expenses/income added')),
                      builder: (ctxx, events, child) {
                        if (events.items.isEmpty) {
                          return child as Widget;
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: events.items.length,
                          itemBuilder: (ctx, i) => _accountingItem(ctx, i, events.items[i]),
                        );
                      }),
            )),
          ),
        ),
        Center(child: (CreateAccountingForm(raiseId: raiseId)))
      ],
    );
  }

  Widget _accountingItem(BuildContext context, int index, Accounting accounting) {
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
              Provider.of<Accountings>(context, listen: false)
                  .deleteAccounting(context: context, accounting: accounting);
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
              _startEditAccounting(context, accounting);
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
              accounting.description,
            ),
            subtitle: Text(accounting.entryType),
            trailing: Text(accounting.amount.toString()),
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

  void _startEditAccounting(BuildContext ctx, Accounting accounting) {
    final descriptionController = TextEditingController();
    descriptionController.text = accounting.description;
    final amountController = TextEditingController();
    amountController.text = accounting.amount.toString();

    final dropdownMenuOptions =
        ENTRY_TYPE.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList();
    String entryType = accounting.entryType;

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
                    const Text('Add new entry.'),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Description'),
                      controller: descriptionController,
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
                            items: dropdownMenuOptions,
                            value: entryType,
                            onChanged: (value) {
                              setState(() {
                                entryType = value as String;
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
                            controller: amountController,
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
                              setState(
                                () {
                                  accounting.description = descriptionController.text;
                                  accounting.entryType = entryType;
                                  accounting.amount = double.parse(amountController.text);
                                  _updateAccounting(context, accounting);
                                  Navigator.pop(context);
                                },
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Update Event'))
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> _updateAccounting(ctx, Accounting accounting) async {
    Provider.of<Accountings>(ctx, listen: false).updateAccounting(context: context, accounting: accounting);
  }
}
