import 'package:flutter/material.dart';
import 'package:kuis_mobile/views/home.dart';
import 'package:kuis_mobile/views/profil.dart';

class Root extends StatefulWidget {
  final String username;
  final String displayName;
  final int initialIndex;
  final String initialCategory;

  const Root({
    super.key,
    required this.username,
    required this.displayName,
    this.initialIndex = 0,
    this.initialCategory = "Semua",
  });

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late int _selectedIndex;
  late String _currentCategory;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _currentCategory = widget.initialCategory;
  }

  void _openWishlistInHome() {
    setState(() {
      _currentCategory = "Wishlist";
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        initialCategory: _currentCategory,
        onCategoryChanged: (cat) {
          _currentCategory = cat;
        },
      ),
      ProfilePage(
        username: widget.username,
        displayName: widget.displayName,
        onWishlistTap: _openWishlistInHome,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1A1A1A),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
