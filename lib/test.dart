import 'package:flutter/material.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  

  final List<List<Widget>> _screenStacks = [
    [const HomeScreen()],    
    [const SearchScreen()],  
    [const ProfileScreen()], 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _pushScreen(Widget screen) {
    setState(() {
      _screenStacks[_selectedIndex].add(screen);
    });
  }

  void _popScreen() {
    setState(() {
      if (_screenStacks[_selectedIndex].length > 1) {
        _screenStacks[_selectedIndex].removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_screenStacks[_selectedIndex].length > 1) {
          _popScreen();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: _screenStacks[_selectedIndex].length > 1
            ? AppBar(
                title: const Text('Detail Screen'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _popScreen,
                ),
              )
            : AppBar(title: const Text('Main App')),
        body: _screenStacks[_selectedIndex].last,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Home Screen'),
          ElevatedButton(
            onPressed: () {
              // Get the MainScreen state
              final mainState = context.findAncestorStateOfType<_MainScreenState>();
              mainState?._pushScreen(const DetailScreen());
            },
            child: const Text('Open Detail Screen'),
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Search Screen'),
          ElevatedButton(
            onPressed: () {
              final mainState = context.findAncestorStateOfType<_MainScreenState>();
              mainState?._pushScreen(const DetailScreen());
            },
            child: const Text('Open Search Detail'),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Profile Screen'),
          ElevatedButton(
            onPressed: () {
              final mainState = context.findAncestorStateOfType<_MainScreenState>();
              mainState?._pushScreen(const DetailScreen());
            },
            child: const Text('Open Profile Detail'),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Detail Screen'),
    );
  }
}