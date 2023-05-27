import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pma/providers/raise.dart';
import 'package:pma/providers/user.dart';
import 'package:pma/screens/hog_detail_screen.dart';
import 'package:pma/screens/signin_screen.dart';
import 'package:pma/screens/update_password_screen.dart';
import 'package:pma/services/auth_service.dart';
import 'package:pma/widgets/custom_button.dart';
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
        title: Text('Raised Hog', style: Theme.of(context).textTheme.headlineLarge,),
      ),
      endDrawer: Drawer(
        child: ListView(
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
      key: const ValueKey(0),
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
    bool _validateName = false;
    bool _validatePenName = false;
    bool _validateHeadCount= false;
    _nameController.text = raise.name;
    _headCountController.text = raise.headCount.toString();
    _pigPenController.text = raise.hogPen;
    _raiseType = raise.raiseType;

    showModalBottomSheet(
        backgroundColor: GlobalVariables.backgroundColor,
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(

              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('Update livestock to raise',  style: Theme.of(context).textTheme.headlineSmall,),
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
                                  onTap: () {
                        
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
                                        final Raise updateRaise = Raise(
                                            id: raise.id,
                                            raiseType: _raiseType,
                                            headCount: int.parse(_headCountController.text),
                                            name: _nameController.text,
                                            hogPen: _pigPenController.text);
                                        _updateRaise(ctx, updateRaise);
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
