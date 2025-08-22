import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animehome/data/services/anime_api_service.dart';
import 'package:animehome/data/services/smart_cache_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class AnimeGalleryScreen extends StatefulWidget {
  final int animeId;
  final String animeTitle;

  const AnimeGalleryScreen({
    super.key,
    required this.animeId,
    required this.animeTitle,
  });

  @override
  State<AnimeGalleryScreen> createState() => _AnimeGalleryScreenState();
}

class _AnimeGalleryScreenState extends State<AnimeGalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> _images = [];
  List<VideoModel> _videos = [];
  bool _isLoadingImages = true;
  bool _isLoadingVideos = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadGalleryData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadGalleryData() async {
    // Load images with cache
    try {
      // Avval cache'dan tekshirish
      final cachedImages = SmartCacheService.getCachedAnimeImages(
        widget.animeId,
      );

      if (cachedImages != null && cachedImages.isNotEmpty) {
        // Cache'dan yuklash
        setState(() {
          _images = cachedImages;
          _isLoadingImages = false;
        });
        print('✅ Loaded ${cachedImages.length} images from cache');
      } else {
        // Internet'dan yuklash
        final hasInternet = await SmartCacheService.hasInternetConnection();
        if (hasInternet) {
          final images = await AnimeApiService.getAnimeImages(widget.animeId);
          setState(() {
            _images = images;
            _isLoadingImages = false;
          });

          // Cache'ga saqlash
          if (images.isNotEmpty) {
            SmartCacheService.cacheAnimeImages(widget.animeId, images);
          }
          print('✅ Loaded ${images.length} images from API');
        } else {
          setState(() {
            _error = 'Internet yo\'q va cache\'da rasmlar mavjud emas';
            _isLoadingImages = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoadingImages = false;
      });
    }

    // Load videos (faqat online)
    try {
      final hasInternet = await SmartCacheService.hasInternetConnection();
      if (hasInternet) {
        final videos = await AnimeApiService.getAnimeVideos(widget.animeId);
        setState(() {
          _videos = videos;
          _isLoadingVideos = false;
        });
      } else {
        setState(() {
          _isLoadingVideos = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingVideos = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.animeTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.photo_library), text: 'Rasmlar'),
            Tab(icon: Icon(Icons.video_library), text: 'Videolar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildImagesTab(), _buildVideosTab()],
      ),
    );
  }

  Widget _buildImagesTab() {
    if (_isLoadingImages) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Rasmlarni yuklashda xatolik',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoadingImages = true;
                  _error = null;
                });
                _loadGalleryData();
              },
              child: const Text('Qayta urinish'),
            ),
          ],
        ),
      );
    }

    if (_images.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Rasmlar topilmadi',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showImageViewer(index),
          child: Hero(
            tag: 'image_$index',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImageWidget(_images[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideosTab() {
    if (_isLoadingVideos) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    if (_videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Videolar topilmadi',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final video = _videos[index];
        return Card(
          color: const Color(0xFF2A2A2A),
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.orange),
            ),
            title: Text(
              video.title,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'YouTube Video',
              style: TextStyle(color: Colors.grey[400]),
            ),
            trailing: const Icon(Icons.open_in_new, color: Colors.orange),
            onTap: () => _openVideo(video),
          ),
        );
      },
    );
  }

  void _showImageViewer(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ImageViewerScreen(images: _images, initialIndex: initialIndex),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    // Local fayl yoki URL ekanligini tekshirish
    if (imagePath.startsWith('/') || imagePath.startsWith('file://')) {
      // Local fayl
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[800],
          child: const Icon(Icons.error, color: Colors.white),
        ),
      );
    } else {
      // Network URL
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[800],
          child: const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[800],
          child: const Icon(Icons.error, color: Colors.white),
        ),
      );
    }
  }

  Future<void> _openVideo(VideoModel video) async {
    try {
      String? videoUrl;

      // YouTube URL'ni aniqlash
      if (video.url != null && video.url!.isNotEmpty) {
        videoUrl = video.url;
      } else if (video.youtubeId != null && video.youtubeId!.isNotEmpty) {
        videoUrl = 'https://www.youtube.com/watch?v=${video.youtubeId}';
      }

      if (videoUrl != null) {
        final Uri url = Uri.parse(videoUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw 'YouTube ochib bo\'lmadi';
        }
      } else {
        throw 'Video URL topilmadi';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video ochishda xatolik: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class ImageViewerScreen extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const ImageViewerScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Center(
            child: Hero(
              tag: 'image_$index',
              child: InteractiveViewer(
                child: _buildFullImageWidget(images[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFullImageWidget(String imagePath) {
    if (imagePath.startsWith('/') || imagePath.startsWith('file://')) {
      // Local fayl
      return Image.file(
        File(imagePath),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.error, color: Colors.white, size: 64),
        ),
      );
    } else {
      // Network URL
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.error, color: Colors.white, size: 64),
        ),
      );
    }
  }
}
