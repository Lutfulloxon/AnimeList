import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animehome/presentation/theme/theme_provider.dart';
import 'package:animehome/presentation/likes/likes_provider.dart';
import 'package:animehome/presentation/home/widgets/anime_card.dart';
import 'package:animehome/l10n/app_localizations.dart';

class LikesScreen extends StatelessWidget {
  const LikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer2<ThemeProvider, LikesProvider>(
      builder: (context, themeProvider, likesProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.myListTitle,
                              style: TextStyle(
                                color: themeProvider.primaryTextColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizations.favoriteCollection,
                              style: TextStyle(
                                color: themeProvider.secondaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<LikesProvider>(
                        builder: (context, likesProvider, child) {
                          return IconButton(
                            icon: Icon(
                              Icons.clear_all_rounded,
                              color: themeProvider.secondaryTextColor,
                            ),
                            onPressed: likesProvider.favoriteAnimes.isEmpty
                                ? null
                                : () {
                                    _showClearAllDialog(
                                      context,
                                      likesProvider,
                                      localizations,
                                    );
                                  },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Body content
                Expanded(
                  child: Consumer<LikesProvider>(
                    builder: (context, likesProvider, child) {
                      return likesProvider.favoriteAnimes.isEmpty
                          ? _buildEmptyState(localizations)
                          : Column(
                              children: [
                                // Favorites info
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        localizations.favoriteAnimes,
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          '${likesProvider.favoriteAnimes.length} ${localizations.count}',
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: _buildFavoritesList(likesProvider),
                                ),
                              ],
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            localizations.noFavoriteAnimesYet,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.tapHeartToFavorite,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              // Home sahifasiga o'tish
            },
            icon: const Icon(Icons.explore),
            label: Text(localizations.viewAnimes),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(LikesProvider likesProvider) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: likesProvider.favoriteAnimes.length,
      itemBuilder: (context, index) {
        return AnimeCard(anime: likesProvider.favoriteAnimes[index]);
      },
    );
  }

  void _showClearAllDialog(
    BuildContext context,
    LikesProvider likesProvider,
    AppLocalizations localizations,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          localizations.deleteAllFavorites,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          localizations.confirmDeleteAllFavorites,
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              likesProvider.clearAllFavorites();
            },
            child: Text(
              localizations.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
