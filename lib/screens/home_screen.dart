import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pma/providers/raise.dart';
import 'package:pma/providers/user.dart';
import 'package:pma/screens/hog_detail_screen.dart';
import 'package:pma/screens/signin_screen.dart';
import 'package:pma/screens/update_password_screen.dart';
import 'package:pma/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';
import '../helpers/global_variables.dart';
import '../models/raise.dart';
import '../widgets/create_raise_form.dart';
import 'auth_screen.dart';

class RaiseScreen extends StatefulWidget {
  static const String routeName = '/raise';

  const RaiseScreen({super.key});

  @override
  State<RaiseScreen> createState() => _RaiseScreenState();
}

class _RaiseScreenState extends State<RaiseScreen> {
  final _nameController = TextEditingController();
  final _headCountController = TextEditingController();
  final _pigPenController = TextEditingController();

  //final AuthService authService = AuthService();

  String _raiseType = '';

  final _dropdownMenuOptions =
      RAISE_TYPES.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        title: const Text('Raised Hog'),
        // leading: GestureDetector(
        //   onTap: () {},
        //   child: const Icon(
        //     Icons.menu, // add custom icons also
        //   ),
        // ),
        // actions: <Widget>[
        //   IconButton(
        //       onPressed: () {
        //         startCreateNewRaise(context);
        //       },
        //       icon: const Icon(Icons.add))
        // ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: GlobalVariables.backgroundColor,
              ),
              child: Text('About HogMaster'),
            ),
            ListTile(
              title: const Text('Change Password'),
              onTap: () {
                Navigator.of(context).pushNamed(UpdatePasswordScreen.routeName);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Provider.of<UserProvider>(context, listen: false).logoutUser(context);
                Navigator.of(context).pushNamed(
                  SigninScreen.routeName,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Provider.of<Raises>(context, listen: false).fetchRaises(context);
              },
              child: SingleChildScrollView(
                  child: FutureBuilder(
                future: Provider.of<Raises>(context, listen: false).fetchRaises(context),
                builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Consumer<Raises>(
                        child: const Center(child: Text('No raised hog added')),
                        builder: (ctxx, raises, child) {
                          if (raises.items.isEmpty) {
                            return child as Widget;
                          }
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: raises.items.length,
                            itemBuilder: (ctx, i) => _raiseItem(ctx, i, raises.items[i]),
                          );
                        }),
              )),
            ),
          ),
          const Center(child: (CreateRaiseForm()))
        ],
      ),
    );
  }

  Widget _raiseItem(BuildContext context, int index, Raise raise) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.
      // startActionPane: ActionPane(
      //   // A motion is a widget used to control how the pane animates.
      //   motion: const ScrollMotion(),

      //   // A pane can dismiss the Slidable.
      //   dismissible: DismissiblePane(onDismissed: () {}),

      //   // All actions are defined in the children parameter.
      //   children: [
      //     // A SlidableAction can have an icon and/or a label.
      //     SlidableAction(
      //       onPressed: (_) {
      //         Provider.of<Raises>(context, listen: false).deleteRaise(context: context, raise: raise);
      //       },
      //       backgroundColor: const Color(0xFFFE4A49),
      //       foregroundColor: Colors.white,
      //       icon: Icons.delete,
      //       label: 'Delete',
      //     ),
      //     SlidableAction(
      //       onPressed: (_) {},
      //       backgroundColor: const Color(0xFF21B7CA),
      //       foregroundColor: Colors.white,
      //       icon: Icons.share,
      //       label: 'Share',
      //     ),
      //   ],
      // ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (_) {
              _startEditRaise(context, raise);
            },
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) {
              Provider.of<Raises>(context, listen: false).deleteRaise(context: context, raise: raise);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: GestureDetector(
          child: ListTile(
            title: Text(
              raise.name,
            ),
            subtitle: Text('Raise type: ${raise.raiseType}'),
            trailing: Text(
              raise.headCount.toString(),
            ),
          ),
          onDoubleTap: () {
            setState(() {
              // indexToEdit = index;
              // _editNameController.text = budget.name;
            });
            //startEditBudget(context, budget);
          },
          onTap: () {
            Navigator.of(context)
                .pushNamed(
              HogDetailScreen.routeName,
              arguments: raise,
            )
                .then((_) {
              setState(() {});
            });
          }),
    );
  }

  void startCreateNewRaise(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: CreateRaiseForm(),
              ));
        });
  }

  Future<void> _updateRaise(ctx, Raise raise) async {
    Provider.of<Raises>(ctx, listen: false).updateRaise(context: context, raise: raise);
  }

  void _startEditRaise(BuildContext ctx, Raise raise) {
    _nameController.text = raise.name;
    _headCountController.text = raise.headCount.toString();
    _pigPenController.text = raise.hogPen;
    _raiseType = raise.raiseType;

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
                    const Text('Update livestock to raise'),
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
                              final Raise updateRaise = Raise(
                                  id: raise.id,
                                  raiseType: _raiseType,
                                  headCount: int.parse(_headCountController.text),
                                  name: _nameController.text,
                                  hogPen: _pigPenController.text);
                              _updateRaise(ctx, updateRaise);
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Update Raise'))
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
