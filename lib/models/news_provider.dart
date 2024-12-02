import 'package:flutter/material.dart';
import '../services/news_api_service.dart';

class Article {
  final String title;
  final String description;
  final String urlToImage;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
  });
}

class NewsProvider with ChangeNotifier {
  final NewsApiService _apiService = NewsApiService();

  List<Article> _articles = [];
  List<Article> _bookmarkedArticles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Article> get articles => [..._articles];
  List<Article> get bookmarkedArticles => [..._bookmarkedArticles];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNews({String query = '', String category = ''}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final articlesData = await _apiService.fetchNews(query: query, category: category);
      _articles = articlesData
          .map((data) => Article(
        title: data['title'] ?? 'No Title',
        description: data['description'] ?? 'No Description',
        urlToImage: data['urlToImage'] ?? '',
      ))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void fetchNewsByCategory(String category) async {
    await fetchNews(category: category);
  }

  void toggleBookmark(Article article) {
    if (_bookmarkedArticles.contains(article)) {
      _bookmarkedArticles.remove(article);
    } else {
      _bookmarkedArticles.add(article);
    }
    notifyListeners();
  }

  void removeBookmark(Article article) {
    _bookmarkedArticles.remove(article);
    notifyListeners();
  }
}


