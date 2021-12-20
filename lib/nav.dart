import 'package:flutter/material.dart';
import 'Attendance.dart';
import 'requests.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  @override

  int _currentIndex = 0;

  final screens = [
    Attendance(),
    Requests(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xffC76060), //Colors.white, const Color(0xff0A0E19),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xffC76060),
        iconSize: 25,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white,),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.white,),
            label: 'Requests',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
