import 'package:flutter/material.dart';
import 'package:pma/helpers/global_variables.dart';
import 'package:pma/models/raise.dart';
import 'package:pma/screens/home_screen.dart';
import 'package:pma/screens/tab_screens/accounting_screen.dart';
import 'package:pma/screens/tab_screens/detail_screen.dart';
import 'package:pma/screens/tab_screens/events_screen.dart';
import 'package:pma/screens/tab_screens/notes_scrent.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    var raise = ModalRoute.of(context)?.settings.arguments as Raise;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 20.0,
            onPressed: () {
              Navigator.of(context).pushNamed(RaiseScreen.routeName);
            },
          ),
          centerTitle: true,
          title: Text('Dashboard', style: Theme.of(context).textTheme.headlineLarge,)
      ),
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(3.0),
                  children: <Widget>[
                    makeDashboardItem("Detail", Icons.book, raise, DetailScreen.routeName),
                    makeDashboardItem("Events", Icons.alarm, raise, EventsScreen.routeName),
                    makeDashboardItem("Notes", Icons.note_add_outlined, raise, NotesScreen.routeName),
                    makeDashboardItem("Accounting", Icons.calculate_outlined, raise, AccountingScreen.routeName),
                    makeDashboardItem("Sow Information", Icons.info, raise, AccountingScreen.routeName),
                    makeDashboardItem("Feeding Guide", Icons.food_bank_sharp, raise, AccountingScreen.routeName)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card makeDashboardItem(String title, IconData icon, Raise raise,String routeName) {
    var onTap;
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        color: Colors.yellow,
        surfaceTintColor: GlobalVariables.btnBackgroundColor,
        child: Container(

          decoration: BoxDecoration(color: GlobalVariables.btnBackgroundColor),
          child: new InkWell(
          
            onTap: () {
              Navigator.of(context).pushNamed(routeName,
               arguments: raise,
              );

            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }
}