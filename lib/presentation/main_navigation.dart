import 'package:animehome/presentation/categories/categories_screen.dart';
import 'package:animehome/presentation/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animehome/presentation/theme/theme_provider.dart';
import 'package:animehome/presentation/home/home_screen.dart';
import 'package:animehome/presentation/likes/likes_screen.dart';
import 'package:animehome/presentation/profile/profile_screen.dart';
import 'package:animehome/l10n/app_localizations.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchPage(),
    const CategoriesScreen(),
    const LikesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        return Scaffold(
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: _buildBottomNavigation(
            themeProvider,
            localizations,
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation(
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: themeProvider.shadowColor,
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 0,
          ),
        ],
        border: Border(
          top: BorderSide(color: themeProvider.borderColor, width: 1),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                Icons.home_rounded,
                0,
                localizations.home,
                themeProvider,
              ),
              _buildNavItem(
                Icons.search_rounded,
                1,
                localizations.search,
                themeProvider,
              ),
              _buildNavItem(
                Icons.grid_view_rounded,
                2,
                localizations.categories,
                themeProvider,
              ),
              _buildNavItem(
                Icons.favorite_rounded,
                3,
                localizations.likes,
                themeProvider,
              ),
              _buildNavItem(
                Icons.person_rounded,
                4,
                localizations.profile,
                themeProvider,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    int index,
    String label,
    ThemeProvider themeProvider,
  ) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? themeProvider.primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: themeProvider.primaryColor.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : themeProvider.secondaryTextColor,
                size: 20,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                color: isSelected
                    ? themeProvider.primaryColor
                    : themeProvider.secondaryTextColor,
                fontSize: isSelected ? 10 : 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.3,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
