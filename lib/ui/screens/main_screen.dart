import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'statistics_screen.dart';
import 'categories_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    StatisticsScreen(),
    CategoriesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: Offset(0, -5),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF3F51B5),
          unselectedItemColor: Colors.grey[400],
          showUnselectedLabels: true,
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Ana Sayfa'),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'İstatistikler'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategoriler'),
          ],
        ),
      ),
    );
  }
}
