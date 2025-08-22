import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animehome/presentation/theme/theme_provider.dart';
import 'package:animehome/presentation/profile/profile_edit_screen.dart';
import 'package:animehome/presentation/settings/settings_provider.dart';
import 'package:animehome/l10n/app_localizations.dart';
import 'package:animehome/data/services/hive_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _userEmail = '';
  String _userBio = '';
  String _userAvatar = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _userName =
          HiveService.getSetting<String>('user_name', defaultValue: '') ?? '';
      _userEmail =
          HiveService.getSetting<String>('user_email', defaultValue: '') ?? '';
      _userBio =
          HiveService.getSetting<String>('user_bio', defaultValue: '') ?? '';
      _userAvatar =
          HiveService.getSetting<String>('user_avatar', defaultValue: '') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer2<ThemeProvider, SettingsProvider>(
      builder: (context, themeProvider, settingsProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: themeProvider.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        localizations.profile,
                        style: TextStyle(
                          color: themeProvider.primaryTextColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: themeProvider.cardColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Icon(
                            Icons.more_vert_rounded,
                            color: themeProvider.iconColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Profile Info
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                themeProvider.primaryColor,
                                themeProvider.primaryColor.withValues(
                                  alpha: 0.7,
                                ),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _userName.isEmpty
                              ? localizations.defaultUserName
                              : _userName,
                          style: TextStyle(
                            color: themeProvider.primaryTextColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userEmail.isEmpty
                              ? localizations.defaultUserEmail
                              : _userEmail,
                          style: TextStyle(
                            color: themeProvider.secondaryTextColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Average consumption
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: themeProvider.cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.averageConsumption,
                          style: TextStyle(
                            color: themeProvider.primaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: themeProvider.accentColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.access_time_rounded,
                                color: themeProvider.primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '15 ${localizations.hoursPerMonth}',
                                  style: TextStyle(
                                    color: themeProvider.primaryTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '1 ${localizations.activeSubscription}',
                                  style: TextStyle(
                                    color: themeProvider.secondaryTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Free Download Banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: themeProvider.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.freeDownload,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                localizations.mangaDescription,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Menu Items
                  _buildMenuItem(
                    context,
                    themeProvider,
                    Icons.person_outline_rounded,
                    localizations.editProfile,
                    () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ),
                      );

                      // Agar profil yangilangan bo'lsa, ma'lumotlarni qayta yuklash
                      if (result == true) {
                        _loadUserData();
                      }
                    },
                  ),

                  Consumer<SettingsProvider>(
                    builder: (context, settingsProvider, child) {
                      return _buildMenuItem(
                        context,
                        themeProvider,
                        Icons.language_outlined,
                        localizations.language,
                        () {
                          _showLanguageDialog(context, settingsProvider);
                        },
                        trailing: settingsProvider.language == 'uz'
                            ? localizations.uzbek
                            : localizations.english,
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    themeProvider,
                    Icons.dark_mode_outlined,
                    localizations.darkMode,
                    () {
                      themeProvider.toggleTheme();
                    },
                    trailingWidget: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: themeProvider.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    ThemeProvider themeProvider,
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? trailing,
    Widget? trailingWidget,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: themeProvider.iconColor, size: 24),
        title: Text(
          title,
          style: TextStyle(
            color: themeProvider.primaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing:
            trailingWidget ??
            (trailing != null
                ? Text(
                    trailing,
                    style: TextStyle(
                      color: themeProvider.secondaryTextColor,
                      fontSize: 14,
                    ),
                  )
                : Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: themeProvider.secondaryTextColor,
                    size: 16,
                  )),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.transparent,
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Tilni tanlang / Choose Language',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇺🇿', style: TextStyle(fontSize: 24)),
              title: const Text(
                'O\'zbek',
                style: TextStyle(color: Colors.white),
              ),
              trailing: settingsProvider.language == 'uz'
                  ? const Icon(Icons.check, color: Color(0xFF00D4AA))
                  : null,
              onTap: () {
                settingsProvider.setLanguage('uz');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: const Text(
                'English',
                style: TextStyle(color: Colors.white),
              ),
              trailing: settingsProvider.language == 'en'
                  ? const Icon(Icons.check, color: Color(0xFF00D4AA))
                  : null,
              onTap: () {
                settingsProvider.setLanguage('en');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish / Cancel'),
          ),
        ],
      ),
    );
  }
}
