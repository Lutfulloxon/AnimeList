import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🚀 Testing Jikan API...');
  
  try {
    final url = 'https://api.jikan.moe/v4/top/anime?page=1&limit=5';
    print('🌐 API Request: $url');
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'AnimeHome/1.0',
      },
    ).timeout(Duration(seconds: 10));
    
    print('📡 API Response: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('📊 API Data keys: ${jsonData.keys}');
      
      if (jsonData['data'] != null) {
        final List<dynamic> animeList = jsonData['data'];
        print('✅ Found ${animeList.length} anime from API');
        
        // Birinchi anime'ni ko'rsatish
        if (animeList.isNotEmpty) {
          final firstAnime = animeList[0];
          print('🎬 First anime: ${firstAnime['title']}');
          print('🆔 ID: ${firstAnime['mal_id']}');
          print('⭐ Score: ${firstAnime['score']}');
        }
      } else {
        print('❌ No data field in response');
      }
    } else {
      print('❌ API Error: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('❌ Network error: $e');
  }
}
