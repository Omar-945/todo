import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Provider/auth_provider.dart';
import 'package:todo/Provider/settings_provider.dart';
import 'package:todo/ui/tabs/notes/add_task.dart';
import 'package:todo/ui/tabs/notes/notes_screen.dart';
import 'package:todo/ui/tabs/settings%20/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? date;

  int index = 0;

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? appbar;
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        icon: Icon(Icons.list),
        label: "",
      ),
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        icon: Icon(Icons.settings),
        label: "",
      ),
    ];
    List<Widget> screens = [NotesScreen(), Settings()];
    if (index == 0) {
      appbar = CalendarAppBar(
        locale: Provider.of<SettingsProvider>(context).local,
        signOut: signOut,
        accent: Colors.blueAccent[100],
        backButton: false,
        onDateChanged: (value) {
          setState(() {
            date = value;
          });
        },
        firstDate: DateTime.now().subtract(Duration(days: 140)),
        lastDate: DateTime.now().add(Duration(days: 30)),
      );
    } else {
      appbar = null;
    }
    return Scaffold(
      appBar: appbar,
      body: screens[index],
      floatingActionButton: Container(
        width: 63,
        height: 63,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: FloatingActionButton(
          shape: StadiumBorder(
              side: BorderSide(
                  width: 4, color: Theme.of(context).colorScheme.onPrimary)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            showNoteButtomSheet();
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Theme.of(context).colorScheme.onBackground,
        clipBehavior: Clip.hardEdge,
        shape: const CircularNotchedRectangle(),
        notchMargin: 13,
        child: BottomNavigationBar(
          elevation: 0,
          items: items,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          currentIndex: index,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }

  void showNoteButtomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddTask(),
    );
  }

  void signOut() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.signOut(context);
  }
}
