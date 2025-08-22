import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animehome/presentation/home/widgets/anime_card.dart';
import 'package:animehome/presentation/theme/theme_provider.dart';
import 'package:animehome/presentation/home/hybrid_anime_provider.dart';
import 'package:animehome/l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredAnime = [];
  List<dynamic> _allAnime = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterAnime);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<HybridAnimeProvider>(context, listen: false);
    _allAnime = provider.animeList;
    _filteredAnime = _allAnime;
  }

  void _filterAnime() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredAnime = _allAnime;
      } else {
        _filteredAnime = _allAnime
            .where(
              (anime) =>
                  anime.title.toLowerCase().contains(query) ||
                  anime.japaneseTitle.toLowerCase().contains(query) ||
                  anime.genres.any(
                    (genre) => genre.toLowerCase().contains(query),
                  ),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              child: Column(
                children: [
                  // Search Header
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeProvider.cardColor.withValues(
                                alpha: 0.7,
                              ),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: themeProvider.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              style: TextStyle(
                                color: themeProvider.primaryTextColor,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: localizations.searchHint,
                                hintStyle: TextStyle(
                                  color: themeProvider.secondaryTextColor,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: themeProvider.primaryColor,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Results Count
                  if (_searchController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${_filteredAnime.length} ${localizations.resultsFound}',
                          style: TextStyle(
                            color: themeProvider.secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Search Results
                  Expanded(
                    child:
                        _filteredAnime.isEmpty &&
                            _searchController.text.isNotEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: themeProvider.tertiaryTextColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  localizations.noResults,
                                  style: TextStyle(
                                    color: themeProvider.secondaryTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  localizations.tryDifferentKeywords,
                                  style: TextStyle(
                                    color: themeProvider.tertiaryTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.6,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 20,
                                ),
                            itemCount: _filteredAnime.length,
                            itemBuilder: (context, index) {
                              return AnimeCard(anime: _filteredAnime[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
