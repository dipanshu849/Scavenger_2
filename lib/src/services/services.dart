import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scavenger_2/src/features/core/model/news_article.dart';

class NewsService {
  final String apiKey =
      '94be1905e6e841db9817d1eeab596ac3'; // Replace with your API key
  // final String baseUrl =
  //     'https://newsapi.org/v2/top-headlines?country=us&apiKey=';
  // final String baseUrl =
  //     'https://newsapi.org/v2/everything?q=environment&apiKey=';

  final String baseUrl =
      'https://newsapi.org/v2/everything?q=waste%20management%20OR%20recycling%20OR%20waste%20reduction&apiKey=';

  // Future<List<NewsArticle>> fetchTopHeadlines() async {
  //   final response = await http.get(Uri.parse('$baseUrl$apiKey'));

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //     final List<dynamic> articlesJson = jsonResponse['articles'];
  //     return articlesJson
  //         .map((article) => NewsArticle.fromJson(article))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load news');
  //   }
  // }
  Future<List<NewsArticle>> fetchTopHeadlines() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$apiKey'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> articlesJson = jsonResponse['articles'];

        // Filter articles to include only those with images
        return articlesJson
            .map((article) => NewsArticle.fromJson(article))
            .where((article) => article
                .urlToImage.isNotEmpty) // Only include articles with images
            .toList();
      } else {
        throw Exception('Failed to load news: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }
}
