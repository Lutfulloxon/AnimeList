import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animehome/presentation/theme/theme_provider.dart';
import 'package:animehome/presentation/home/hybrid_anime_provider.dart';
import 'package:animehome/domain/entities/anime/anime_list_entity.dart';
import 'package:animehome/presentation/home/widgets/anime_card.dart';
import 'package:animehome/presentation/detail/anime_detail_page.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
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
                              'Categories',
                              style: TextStyle(
                                color: themeProvider.primaryTextColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Explore anime by genre',
                              style: TextStyle(
                                color: themeProvider.secondaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Categories Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return _buildCategoryCard(context, category);
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

  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryAnimeScreen(
              categoryName: category.name,
              categoryColor: category.color,
              categoryIcon: category.icon,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              category.color.withValues(alpha: 0.8),
              category.color.withValues(alpha: 0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: category.color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, size: 32, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryModel {
  final String name;
  final Color color;
  final IconData icon;

  CategoryModel({required this.name, required this.color, required this.icon});
}

final List<CategoryModel> _categories = [
  CategoryModel(name: 'Action', color: Colors.red, icon: Icons.flash_on),
  CategoryModel(name: 'Adventure', color: Colors.orange, icon: Icons.explore),
  CategoryModel(
    name: 'Comedy',
    color: Colors.yellow,
    icon: Icons.sentiment_very_satisfied,
  ),
  CategoryModel(
    name: 'Drama',
    color: Colors.purple,
    icon: Icons.theater_comedy,
  ),
  CategoryModel(name: 'Fantasy', color: Colors.pink, icon: Icons.auto_awesome),
  CategoryModel(
    name: 'Horror',
    color: Colors.grey[800]!,
    icon: Icons.nightlight,
  ),
  CategoryModel(
    name: 'Romance',
    color: Colors.pink[300]!,
    icon: Icons.favorite,
  ),
  CategoryModel(name: 'Sci-Fi', color: Colors.cyan, icon: Icons.rocket_launch),
  CategoryModel(name: 'Thriller', color: Colors.indigo, icon: Icons.psychology),
  CategoryModel(
    name: 'Supernatural',
    color: Colors.deepPurple,
    icon: Icons.auto_fix_high,
  ),
  CategoryModel(name: 'Mystery', color: Colors.brown, icon: Icons.search),
  CategoryModel(name: 'Sports', color: Colors.green, icon: Icons.sports_soccer),
  CategoryModel(
    name: 'Slice of Life',
    color: Colors.lightBlue,
    icon: Icons.home,
  ),
  CategoryModel(
    name: 'Historical',
    color: Colors.amber[700]!,
    icon: Icons.history_edu,
  ),
  CategoryModel(
    name: 'Psychological',
    color: Colors.teal,
    icon: Icons.psychology_alt,
  ),
  CategoryModel(name: 'Shounen', color: Colors.blue, icon: Icons.group),
];

class CategoryAnimeScreen extends StatefulWidget {
  final String categoryName;
  final Color categoryColor;
  final IconData categoryIcon;

  const CategoryAnimeScreen({
    super.key,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
  });

  @override
  State<CategoryAnimeScreen> createState() => _CategoryAnimeScreenState();
}

class _CategoryAnimeScreenState extends State<CategoryAnimeScreen> {
  bool _isGridView = true;
  List<AnimeEntity> _animeList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategoryAnime();
  }

  Future<void> _loadCategoryAnime() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final provider = Provider.of<HybridAnimeProvider>(context, listen: false);
      final animeList = await provider.getAnimeByCategory(widget.categoryName);

      setState(() {
        _animeList = animeList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: themeProvider.iconColor,
                            size: 24,
                          ),
                        ),
                        Icon(
                          widget.categoryIcon,
                          color: widget.categoryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.categoryName,
                            style: TextStyle(
                              color: themeProvider.primaryTextColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isGridView = !_isGridView;
                            });
                          },
                          icon: Icon(
                            _isGridView ? Icons.list : Icons.grid_view,
                            color: themeProvider.primaryColor,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(child: _buildContent(themeProvider)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ThemeProvider themeProvider) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00D4AA)),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: themeProvider.secondaryTextColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading anime',
              style: TextStyle(
                color: themeProvider.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(
                color: themeProvider.secondaryTextColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCategoryAnime,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.categoryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_animeList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.categoryIcon,
              size: 64,
              color: themeProvider.secondaryTextColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${widget.categoryName} anime found',
              style: TextStyle(
                color: themeProvider.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try checking other categories',
              style: TextStyle(
                color: themeProvider.secondaryTextColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Anime Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${_animeList.length} anime available',
              style: TextStyle(
                color: themeProvider.secondaryTextColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Anime List/Grid
        Expanded(child: _isGridView ? _buildGridView() : _buildListView()),
      ],
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: _animeList.length,
      itemBuilder: (context, index) {
        return AnimeCard(anime: _animeList[index]);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _animeList.length,
      itemBuilder: (context, index) {
        final anime = _animeList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                anime.imageUrl,
                width: 60,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.movie_rounded,
                      color: Color(0xFF00D4AA),
                      size: 24,
                    ),
                  );
                },
              ),
            ),
            title: Text(
              anime.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFF00D4AA), size: 16),
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
                      '${anime.episodes} Episodes',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF00D4AA),
              size: 16,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeDetailPage(anime: anime),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
