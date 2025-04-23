import 'package:flutter/material.dart';
import 'package:garage/Screens/MapScreen/MapScreen.dart';
import 'package:garage/Screens/Profile/profilescreen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});
  @override
  State createState() => _NavBarState();
}

class _NavBarState extends State {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _Screens() {
    return [
      Mapscreen(),
      Profilescreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _Screens(),
    );
  }
}
