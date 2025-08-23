import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animehome/presentation/home/hybrid_anime_provider.dart';
import 'package:animehome/presentation/home/widgets/anime_card.dart';
import 'package:animehome/presentation/search/search_page.dart';
import 'package:animehome/presentation/all_anime/all_anime_page.dart';
import 'package:animehome/presentation/detail/anime_detail_page.dart';
import 'package:animehome/presentation/theme/theme_provider.dart';
import 'package:animehome/presentation/likes/likes_provider.dart';
import 'package:animehome/l10n/app_localizations.dart';
import 'package:animehome/domain/entities/anime/anime_list_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: themeProvider.backgroundGradient,
              ),
            ),
            child: SafeArea(
              child: Consumer<HybridAnimeProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFF00D4AA),
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.loadingAmazingAnime,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Xatolik yuz berdi',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              provider.error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => provider.init(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00D4AA),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Qayta urinish'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.animeList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            color: Colors.white54,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.noAnimeFoundGeneral,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Internet ulanishini tekshiring',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => provider.init(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00D4AA),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Qayta yuklash'),
                          ),
                        ],
                      ),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      // Custom App Bar
                      SliverAppBar(
                        expandedHeight: 80,
                        floating: false,
                        pinned: true,
                        backgroundColor: Colors.transparent,
                        flexibleSpace: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF0F0F23), Colors.transparent],
                            ),
                          ),
                          child: FlexibleSpaceBar(
                            title: Row(
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
                                  'AniArk',
                                  style: TextStyle(
                                    color: themeProvider.primaryTextColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                            centerTitle: false,
                            titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                          ),
                        ),
                        actions: [
                          IconButton(
                            icon: Icon(
                              themeProvider.isDarkMode
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                              color: themeProvider.iconColor,
                              size: 24,
                            ),
                            onPressed: () {
                              themeProvider.toggleTheme();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.search_rounded,
                              color: themeProvider.iconColor,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      // Hero Section
                      if (provider.animeList.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _buildHeroCarousel(
                            provider.animeList.take(5).toList(),
                            localizations,
                          ),
                        ),

                      // Trending Section
                      SliverToBoxAdapter(
                        child: _buildSectionHeader(
                          localizations.trending,
                          localizations.seeAll,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllAnimePage(animeList: provider.animeList),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _buildTrendingSection(
                          provider.animeList.take(6).toList(),
                        ),
                      ),

                      // Current Season Section
                      if (provider.currentSeasonAnime.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _buildSectionHeader(
                            '🌸 Joriy Mavsum',
                            'Barchasini ko\'rish',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllAnimePage(
                                    animeList: provider.currentSeasonAnime,
                                    title: 'Joriy Mavsum Anime\'lari',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (provider.currentSeasonAnime.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _buildHorizontalAnimeList(
                            provider.currentSeasonAnime.take(6).toList(),
                          ),
                        ),

                      // Upcoming Section
                      if (provider.upcomingAnime.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _buildSectionHeader(
                            '🔮 Kelayotgan Anime\'lar',
                            'Barchasini ko\'rish',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllAnimePage(
                                    animeList: provider.upcomingAnime,
                                    title: 'Kelayotgan Anime\'lar',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (provider.upcomingAnime.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _buildHorizontalAnimeList(
                            provider.upcomingAnime.take(6).toList(),
                          ),
                        ),

                      // Random Anime Section
                      if (provider.randomAnime != null)
                        SliverToBoxAdapter(
                          child: _buildRandomAnimeSection(
                            context,
                            provider.randomAnime!,
                            localizations,
                          ),
                        ),

                      // For You Section
                      SliverToBoxAdapter(
                        child: _buildSectionHeader(
                          localizations.forYou,
                          localizations.seeAll,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllAnimePage(animeList: provider.animeList),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.6,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final startIndex = 6;
                              if (startIndex + index >=
                                  provider.animeList.length) {
                                return const SizedBox();
                              }
                              return AnimeCard(
                                anime: provider.animeList[startIndex + index],
                              );
                            },
                            childCount: (provider.animeList.length - 6).clamp(
                              0,
                              9,
                            ),
                          ),
                        ),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroCarousel(
    List<dynamic> animeList,
    AppLocalizations localizations,
  ) {
    return Container(
      height: 500,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: PageView.builder(
        itemCount: animeList.length,
        itemBuilder: (context, index) {
          final anime = animeList[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: anime.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF1A1A2E),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00D4AA),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFF1A1A2E),
                        child: const Center(
                          child: Icon(
                            Icons.movie_rounded,
                            color: Color(0xFF00D4AA),
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D4AA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            localizations.trending.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          anime.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${localizations.anime} • ${anime.year}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AnimeDetailPage(anime: anime),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.play_arrow_rounded),
                                label: Text(localizations.play),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00D4AA),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Consumer<LikesProvider>(
                                builder: (context, likesProvider, child) {
                                  final isFavorite = likesProvider.isFavorite(
                                    anime.id,
                                  );
                                  return OutlinedButton.icon(
                                    onPressed: () {
                                      likesProvider.toggleFavorite(anime);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isFavorite
                                                ? localizations
                                                      .removedFromFavoritesMessage
                                                : localizations.addedToMyList,
                                          ),
                                          backgroundColor: isFavorite
                                              ? Colors.grey[600]
                                              : const Color(0xFF00D4AA),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      isFavorite ? Icons.check : Icons.add,
                                    ),
                                    label: Text(
                                      isFavorite
                                          ? localizations.added
                                          : localizations.myList,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                        color: isFavorite
                                            ? const Color(0xFF00D4AA)
                                            : Colors.white,
                                      ),
                                      backgroundColor: isFavorite
                                          ? const Color(
                                              0xFF00D4AA,
                                            ).withValues(alpha: 0.2)
                                          : Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String action, [
    VoidCallback? onTap,
  ]) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: themeProvider.primaryTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  action,
                  style: TextStyle(
                    color: themeProvider.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendingSection(List<dynamic> animeList) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: animeList.length,
        itemBuilder: (context, index) {
          final anime = animeList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeDetailPage(anime: anime),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(5, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: anime.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: const Color(0xFF1A1A2E),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF00D4AA),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFF1A1A2E),
                          child: const Center(
                            child: Icon(
                              Icons.movie_rounded,
                              color: Color(0xFF00D4AA),
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D4AA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                        child: Text(
                          anime.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Horizontal anime list widget
  Widget _buildHorizontalAnimeList(List<AnimeEntity> animeList) {
    return Container(
      height: 280,
      margin: const EdgeInsets.only(bottom: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: animeList.length,
        itemBuilder: (context, index) {
          final anime = animeList[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimeDetailPage(anime: anime),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Anime Image
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: anime.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFF1A1A2E),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF00D4AA),
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFF1A1A2E),
                            child: const Center(
                              child: Icon(
                                Icons.movie_rounded,
                                color: Color(0xFF00D4AA),
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Anime Title
                  Text(
                    anime.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Rating and Year
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        anime.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        anime.year.toString(),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Random anime section widget
  Widget _buildRandomAnimeSection(
    BuildContext context,
    AnimeEntity anime,
    AppLocalizations localizations,
  ) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00D4AA).withValues(alpha: 0.1),
            const Color(0xFF1A1A2E).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00D4AA).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.casino_rounded,
                color: Color(0xFF00D4AA),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                '🎲 Tasodifiy Anime',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  final provider = Provider.of<HybridAnimeProvider>(
                    context,
                    listen: false,
                  );
                  provider.loadRandomAnime();
                },
                child: const Text(
                  'Yangi',
                  style: TextStyle(
                    color: Color(0xFF00D4AA),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeDetailPage(anime: anime),
                ),
              );
            },
            child: Row(
              children: [
                // Anime Image
                Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: anime.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF1A1A2E),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00D4AA),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFF1A1A2E),
                        child: const Center(
                          child: Icon(
                            Icons.movie_rounded,
                            color: Color(0xFF00D4AA),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Anime Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anime.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            anime.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            anime.year.toString(),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        anime.description,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
