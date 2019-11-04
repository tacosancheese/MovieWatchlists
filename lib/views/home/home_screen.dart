import 'package:flutter/material.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/views/home/discovery_screen.dart';
import 'package:movie_watchlists/views/settings/settings_screen.dart';
import 'package:movie_watchlists/views/watchlist/watchlist_screen.dart';

class HomeScreen extends StatefulWidget {

  static createRoute(final BuildContext ctx) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(
      builder: (context) {
        return HomeScreen();
        //);
      })
    );
  }

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Color unselectedColor = Palette.white82;
  Color selectedColor = Palette.accent;
  Color backgroundColor = Palette.grey;

  int _currentIndex = 0;

  final List<Widget> _children = [
    DiscoveryScreen(),
    WatchlistScreen(),
    SettingsScreen()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_to_home_screen,
              color: _currentIndex == 0 ? selectedColor : unselectedColor
            ),
            title: Text("Discover",
              style: TextStyle(
                color: _currentIndex == 0 ? selectedColor : unselectedColor
              )
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: _currentIndex == 1 ? selectedColor : unselectedColor,
            ),
            title: Text("Watchlists",
              style:
              TextStyle(
                color: _currentIndex == 1 ? selectedColor : unselectedColor
              )
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: _currentIndex == 2 ? selectedColor : unselectedColor,
            ),
            title: Text("Settings",
              style: TextStyle(
                color: _currentIndex == 2 ? selectedColor : unselectedColor
              )
            )
          ),
        ],
        onTap: _onTabTapped,
      ),
    );
  }
}
