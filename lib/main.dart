import 'package:flutter/material.dart';
import 'package:pma/providers/accounting.dart';
import 'package:pma/providers/event.dart';
import 'package:pma/providers/note.dart';
import 'package:pma/providers/raise.dart';
import 'package:pma/providers/user.dart';
import 'package:pma/screens/auth_screen.dart';
import 'package:pma/screens/home_screen.dart';
import 'package:pma/screens/signin_screen.dart';
import 'package:pma/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:pma/router.dart';

import 'helpers/global_variables.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: const FarmApp(),
  ));
}

class FarmApp extends StatefulWidget {
  const FarmApp({super.key});

  @override
  State<FarmApp> createState() => _FarmAppState();
}

class _FarmAppState extends State<FarmApp> {
  //final AuthService authService = AuthService();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Raises>(
            create: (ctx) => Raises(),
          ),
          ChangeNotifierProvider<Notes>(
            create: (ctx) => Notes(),
          ),
          ChangeNotifierProvider<Events>(
            create: (ctx) => Events(),
          ),
          ChangeNotifierProvider<Accountings>(
            create: (ctx) => Accountings(),
          ),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: _messangerKey,
          debugShowCheckedModeBanner: false,
          title: 'Farmland - Piggery',
          theme: ThemeData(
            textTheme: const TextTheme(
              headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
              headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            }),
            scaffoldBackgroundColor: GlobalVariables.backgroundColor,
            colorScheme: const ColorScheme.light(
              primary: GlobalVariables.secondaryColor,
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            useMaterial3: true, // can remove this line
          ),
          onGenerateRoute: (settings) => generateRoute(settings),
          home: Provider.of<UserProvider>(context).user.token.isNotEmpty ? const RaiseScreen() : const SigninScreen(),
        ));
  }
}
