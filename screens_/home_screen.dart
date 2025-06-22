import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';
import 'transaction_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Список экранов для каждой вкладки
  final List<Widget> _screens = [
    TransactionsScreen(),
    TransactionsScreen(),
    ProfileScreen(),
  ];

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: _screens[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: SizedBox(
          height: 140,
          child: Theme(
            data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onNavBarTap,
            backgroundColor: AppColors.accent,
            selectedItemColor: AppColors.surface,
            unselectedItemColor: AppColors.primary,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(18),
                  child: Image.asset(
                    'Assets/Icons/Icon - main_scr_home_inactive.png',
                    width: 24,
                  ),
                ),
                activeIcon: Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(
                    'Assets/Icons/Icon - main_scr_home_active.png',
                    width: 24,
                  ),
                ),
                label: 'Транзакции',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(18),
                  child: Image.asset(
                    'Assets/Icons/Icon - main_scr_bugdets_inactive.png',
                    width: 24,
                  ),
                ),
                activeIcon: Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(
                    'Assets/Icons/Icon - main_scr_bugdets_active.png',
                    height: 24,
                  ),
                ),
                label: 'Аналитика',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(18),
                  child: Image.asset(
                    'Assets/Icons/Icon - main_scr_settings_inactive.png',
                    width: 24,
                  ),
                ),
                activeIcon: Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(
                    'Assets/Icons/Icon - main_scr_settings_active.png',
                    height: 24,
                  ),
                ),
                label: 'Профиль',
               ),
             ],
            ),
          ),
        ),
      )
    );
  }
}