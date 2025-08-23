import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animehome/presentation/home/widgets/anime_card.dart';
import 'package:animehome/presentation/detail/anime_detail_page.dart';
import 'package:animehome/presentation/theme/theme_provider.dart';

class AllAnimePage extends StatefulWidget {
  final List<dynamic> animeList;
  final String? title;

  const AllAnimePage({super.key, required this.animeList, this.title});

  @override
  State<AllAnimePage> createState() => _AllAnimePageState();
}

class _AllAnimePageState extends State<AllAnimePage> {
  bool _isGridView = true;

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
                        Expanded(
                          child: Text(
                            widget.title ?? 'All Anime',
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

                  // Anime Count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${widget.animeList.length} anime available',
                        style: TextStyle(
                          color: themeProvider.secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Anime List/Grid
                  Expanded(
                    child: _isGridView ? _buildGridView() : _buildListView(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
      itemCount: widget.animeList.length,
      itemBuilder: (context, index) {
        return AnimeCard(anime: widget.animeList[index]);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: widget.animeList.length,
      itemBuilder: (context, index) {
        final anime = widget.animeList[index];
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
