// class NewsArticle {
//   final String title;
//   final String description;
//   final String urlToImage;

//   NewsArticle(
//       {required this.title,
//       required this.description,
//       required this.urlToImage});

//   factory NewsArticle.fromJson(Map<String, dynamic> json) {
//     return NewsArticle(
//       title: json['title'] ?? 'No Title',
//       description: json['description'] ?? 'No Description',
//       urlToImage: json['urlToImage'] ?? '',
//     );
//   }
// }

class NewsArticle {
  final String title;
  final String url; // Ensure this property exists
  final String urlToImage;
  final String description;

  NewsArticle({
    required this.title,
    required this.url,
    required this.urlToImage,
    required this.description,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title', // Provide default values if null
      url: json['url'] ?? 'https://example.com', // Provide a default URL
      urlToImage: json['urlToImage'] ??
          'https://example.com/default-image.jpg', // Default image
      description:
          json['description'] ?? 'No Description', // Default description
    );
  }
}
