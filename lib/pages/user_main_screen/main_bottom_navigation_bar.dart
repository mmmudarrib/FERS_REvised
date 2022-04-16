import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AppProvider _navBar = Provider.of<AppProvider>(context);
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
      selectedItemColor: Theme.of(context).primaryColor,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      unselectedItemColor: Colors.grey,
      currentIndex: _navBar.currentBottonTap,
      onTap: (int index) {
        _navBar.updateBottomTap(index);
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.emergency,
            color: Colors.red,
          ),
          label: 'SOS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.checklist),
          label: 'Records',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: 'Profile',
        ),
      ],
    );
  }
}
