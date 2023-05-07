import 'package:flutter/material.dart';

class AccountingScreen extends StatefulWidget {
  const AccountingScreen({super.key});

  @override
  State<AccountingScreen> createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.calculate);
  }
}
