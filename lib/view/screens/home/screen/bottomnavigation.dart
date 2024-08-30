
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/view/screens/allusers/screen/allusers_screen.dart';
import 'package:adhiriya_ai_webapp/view/screens/profile/screen/profile_screen.dart';
import 'package:flutter/material.dart';

import '../homescreen.dart';

class Bottomnavigation extends StatefulWidget {
  final String role;

  const Bottomnavigation({super.key, required this.role});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _adminPages = <Widget>[
    Homescreen(role: 'Admin'),
    AllusersScreen(),
    ProfileScreen(),
  ];

  static const List<Widget> _userPages = <Widget>[
    Homescreen(role: 'User'),
    ProfileScreen(),
  ];

  List<BottomNavigationBarItem> _getNavBarItems() {
    if (widget.role == 'Admin') {
      return  <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: Appstring.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.people),
          label: Appstring.allUsers,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: Appstring.profile,
        ),
      ];
    } else {
      return  <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: Appstring.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: Appstring.profile,
        ),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.role == 'Admin' ? _adminPages : _userPages;

    return Scaffold(
      body: Center(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _getNavBarItems(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
