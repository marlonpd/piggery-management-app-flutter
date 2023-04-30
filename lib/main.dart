import 'package:flutter/material.dart';
import 'package:pma/providers/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),

  ], child: const FarmApp(),));
}


class FarmApp extends StatefulWidget {
  const FarmApp({super.key});

  @override
  State<FarmApp> createState() => _FarmAppState();
}

class _FarmAppState extends State<FarmApp> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}